Pixelated-Platform
==================

**Pixelated is in early development stage! Things may not work to their full extent yet**

It is the objective of the Pixelated Platform to provide a simple to install and maintain mail server based on the LEAP Platform.

* The Pixelated Platform holds the installation scripts for the Pixelated components.
* In this repository, you also find the Pixelated Threat Model (currently in development)

You need a running leap platform to use pixelated.
Please refer to https://leap.se/en/docs/platform/tutorials/single-node-email to set up a leap provider.

## Installing Pixelated on your existing leap installation

We have puppet scripts that take care of everything.
This will install the pixelated-dispatcher and the pixelated-user-agent
and will enable your users to use webmail with your leap platform.
Add our repository to files/puppet inside your leap configuration folder.
The easiest way to do this is to change to your leap configuration folder and run
```bash
git submodule add https://github.com/pixelated-project/pixelated-platform.git files/puppet
```



