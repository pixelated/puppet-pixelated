# Pixelated Threat-Model
WORK IN PROGRESS
Please try to use markdown syntax so we are able to post it on github etc.
There is a manual but more or less regular backup to http://gitlab.dfi.local/dfi/threat-model

## Threat Model Information
###Description
A software distribution that helps organisations implement a secure* email/groupware solution. It combines LEAP as an encrypted mail provider with Mailpile as UI into a web based frontend

(*)In this context secure means that communication cannot be intercepted trivially by adversary parties. The goal is not, and arguably cannot be, to make communiction secure against all known and unknown adversaries.
###Participants
Folker Bernitt, Christoph Klünter, Smari McCarthy, Lisa Junger

## Assumptions
* Platform providers obtain an authentic copy of Pixelated
* Users have some kind of certificate check in place (e.g. do not accept untrusted certificates)
* The servers running the platform are not compromised by malware
* The security assumptions of used crypto are valid
## External dependencies
1. The pixelated platform is hosted on one or more linux servers. The distribution is not fixed, so ubuntu, debian, centos or RHEL are valid choices. The servers will be hardened using the puppet scripts provided by LEAP platform. The patch level for the OS depends on the chosen platform.
2. The backend service is provided by the  [LEAP](https://www.leap.se "LEAPs homepage")
3. The MUA is provided by [Mailpile](https://www.mailpile.is "Mailpiles homepage")
4. The frontend in form of the Mailpile dispatcher is a custom development by the pixelated team
5. The pixelated platform only provides encrypted access to its various services, e.g. HTTPS or SMTPS (see below for details about boundaries)
## Entry Points

|Name|Protocol|Port|encryption|auth|description|
|-------|----|----------|-----------|
|SSH|SSH|22|SSH|authorized keys|ssh access| |SMTP|SMTP|25|STARTTLS| | |
|SMTP|SMTP|465|STARTTLS|ssh client auth | | |SMTP|SMTP|487|STARTTLS| | |
|Web|HTTP|80|none| |Redirects to HTTPS|
|Web|HTTPS|443|SSL/TLS| |Different web-applications, e.g. user and admin interface|
|api|HTTPS|4430|SSL/TLS|session-id| | |
|Nicknym|HTTPS|6425|SSL/TLS| |Key lookup service|
|Soledad|?|2323|?| |Couchdb external interface|
## Assets/Data
### Encrypted mails
- - Symetrically encrypted mails stored in a couchdb database
- - GPG encrypted mails stored in a couchdb database (incoming mail)
- GPG public and private key
- - Being a SaaS model the server needs access to the (encrypted) private key
- - - The key needs to be unlocked on the server-side, therefore the server needs access to the plaintext passphrase as well
- - LEAP provides a key look service (key server) which provides public keys for all registered users
- - The intention of the pixelated plattform is to never persist unencrypted mail on the server
### User credentials
- - The server has to keep a list of user credentials (username and password) to authenticate and authorize users
- - The password might either be used directly as the gpg passphrase or to unlock the gpg private key passphrase
### Email adressess
- - The server stores a list of all valid email adresses
- - - Poorly chosen can hint to the owner
### Mailpile persisted data
All data that mailpile persists is stored on the server, among others this includes
- keyword search index (with hashed  and salted keywords)
- encrypted config file
- encrypted mail index
- encrypted contacts/vcards
- (currently) unencrypted logfile with web requests
### LEAP persited data
All data that the LEAP provider persists
- Logfiles (SMTP, HTTP, couchdb)
- encrypted mails in couchdb
### Log files
- - Some typical server logs are gerenated, IP adresses have to be anonymized as good as possible
- - Might reveal user behaviour like times when mails are read
## Data Transports at boundaries
### HTTPS access through Web-Frontend
The pixelated plattform provides a web front by which users can access (read and write) emails. This transport is secured using a recent SSL version. Using perfect forward secrecy is mandatory.  Each user has full access to his account. Mails are moved unencrypted through this transport (decryption happens on the server).
### SMTP (encrypted with plaintext fallback)
Pixelated provides a mail service and uses SMTP to forward mails to their receipients. There is a best effort mechanism in place to send mails by encrypted transport. But if that fails there is a fallback in place using plaintext only.
Note: Pixelated tries to encrypt the mail body with GPG whenever possible. Therefore Pixelated can leak metadata in form of headers when using the SMTP protocol. It is planned to add an option to abort forwarding mails if content encryption is not possible (i.e. no valid public key is known for all recipients)
### LEAP web frontend
Pixelated provides access to the LEAP provider web frontend. This is necessary to allow direct login to the LEAP provider and avoiding the Pixelated Web-Frontend
### LEAP soledad API
Provides access to the mail database of each user. 
- Secured by auth token aquired by SRP login on LEAP server
- Seems to be a protocol on top of HTTPS
- Port has to be accessible from the outside to support direct client access
### LEAP Nicknym API
Provides a key lookup services that allows access to public keys of all known users
- RESTful service on top of HTTPS
- Service uses no authentication and only has access to pulic key data
- Port has to be accessible from the outside to support direct client access as well as server to server lookup
### SSH access for Administration
All services provide SSH access for administration and maintenance. It allows key based authentication only and does not allow password login
## Data Transports internal
### Couchdb cluster
Couchdb, i.e. bigcouch, synchronises itself over a HTTP protocol. Most of the content couchdb has access to is encrypted (either symetrically or by GPG).
Unencrypted data:
    - hashed user ids
    - documents (each one representing an encrypted email)
    - document ids
    - document versions
    - document timestamps
### Nagios Monitoring
LEAP sets up Nagios to monitor the instances. Analysis of how Nagios accesses hosts is pending
## Trust Levels
|Nr|Name|login Page|Nicknym Service|Soledad Service|Mailpile Service|Direct accessible from Internet|
|--|----|----------|---------------|---------------|----------------|------------------------|
|1.| Anoymous Web User|Yes|Yes|No|No|Yes|
|2.|User with invalid login credentials|Yes|Yes|No|No|Yes|
|3.|User with valid login credentials|Yes|yes|Yes|Yes|Yes|
|4.|Nicknym user|Yes|Yes|No|No|Yes|
|5.|Soledad user|Yes|Yes|Yes|No|Yes|
|5.|Multipile Server Process|Yes|Yes|Yes|Yes|No|
|6.|Multipile Dispatcher Process|Yes|Yes|No|Yes|Yes|
|7.|Admin user|Yes|Yes|yes|yes|No|
## System Users / Privilege Seperation
As multiple users are accessing the pixelated platform it is important to isolate the users from each other as good as possible to avoid accidental access to secret data. For achiving purposes it makes sense to implement some kind of privilege seperation.
TBD
## Encryption Cyphers and Tools
### HTTPS
- TBD: List of allowed cyphers
- TBD: List of supported browsers
### Languages, Tools, Libraries
## Known problems
### GPG Passphrase
### Web based - what does that mean
## STRIDE
A threat categorization such as STRIDE is useful in the identification of threats by classifying attacker goals such as: 
### Spoofing 
### Tampering 
### Repudiation 
### Information Disclosure 
### Denial of Service 
### Elevation of Privilege.
## Scenarios
### What the platform provider of an uncompromised server can achieve:
* It can learn when a user is online and accessing his mail
* It can learn how many mails a user sends and receives
* It can learn timestamps about sent and received mail
* It can learn the approximate size of any mail sent or received
* It can access the (encrypted) private key of any user
* It can delete or corrupt mails of users
* It can spam users with messages
* It can duplicate messages
### What a global, passive adversay (one who can observe all Internet traffic) can achieve:
This is the use case for Pixelated.
* The adversary can learn who is using the pixelated plattform
* The adversary can learn when messages are sent or received
* The adversary can learn to what destination servers messages are sent
* The adversary can learn from which source servers messages are received
* The adversary can learn which user is the sender of an outgoing message with high probability (time correlation)
* The adversary can learn from which servers public GPG keys are requested
* The adversary can read mail headers if mails are sent to servers not supporting encryption
### What a physical seizure of a server can achieve
* Access to LEAP database with encrypted data
* Access to all users Mailpile encrypted mailpile data
* Access to encrypted private keys
* Possible key material or mail content in swap space
Possible mitigation: Encrypt disks (still vulnarable by cold boot attack)
### What a hijacked server can achieve
Same as seizure as well as:
* Access to user passwords by manipulated dispatcher and by this access to unlocked private keys
### What a physical seizure of a users computer can achieve
If user only uses web-client: 
* Files in Browser caches
If  user uses local Mailpile installation
* Access to encrypted or hashed Mailpile data. See Mailpile threat-model for more details
If user uses LEAP's Bitmask client
* Access to encrypted Bitmask database and possible access to unencrypted mails, e.g. if user accesses Bitmask through Thunderbird, etc.
## Some useful links
- https://www.owasp.org/index.php/Application_Threat_Modeling
- leap threat model? Might be: https://leap.se/en/doc/tech/limitations
- http://blogs.msdn.com/b/larryosterman/archive/2007/09/21/threat-modeling-again-threat-modeling-rules-of-thumb.aspx
- nice threatmodel: https://pond.imperialviolet.org/threat.html

