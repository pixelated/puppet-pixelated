#!/usr/bin/env python

# under development
# from https://github.com/leapcode/leap_web/blob/develop/test/integration/api/python/flow_with_srp.py

import requests
import srp._pysrp as srp
import binascii
import argparse


safe_unhexlify = lambda x: binascii.unhexlify(x) if (len(x) % 2 == 0) else binascii.unhexlify('0' + x)
# using globals for now
# server = 'https://dev.bitmask.net/1'
server = 'https://unstable.pixelated-project.org/1'


def signup(invite, login, password):
    salt, vkey = srp.create_salted_verification_key(login, password, srp.SHA256, srp.NG_1024)
    user_params = {
        'user[invite_code]': invite,
        'user[login]': login,
        'user[password_verifier]': binascii.hexlify(vkey),
        'user[password_salt]': binascii.hexlify(salt)
    }
    session = requests.session()
    session.get(server, verify=False)
    response = session.post(server + '/users.json',
                            data=user_params, verify=False,
                            cookies=session.cookies,
                            headers=session.headers)
    if response.status_code not in [200, 201]:
        raise Exception("%s error at signup: %s" % (response.status_code, response.text))
    return response


def login(username, password):
    session = requests.session()
    url = 'https://unstable.pixelated-project.org:8080'
    session.get(url, verify=False)
    data = {'login': 'Login',
            'password': password,
            'username': username,
            '_xsrf': session.cookies['_xsrf']}
    response = session.post(('%s/auth/login' % url),
                            data=data, verify=False,
                            cookies=session.cookies,
                            headers=session.headers)
    if 'Invalid credentials' in response.text:
        raise Exception('We just got "Invalid credentials" for: %s' % username)
    if response.status_code is not 200:
        raise Exception("%s error at login: %s" % (response.status_code, response.text))
    print username + " has logged in!"
    return response


def consume_invites(invites, prefix, start, password):
    for invite in invites:
        if not invite.strip():
            continue
        username = prefix + str(start)
        signup(invite, username, password)
        login(username, password).text


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="creates and logins multiple accounts from a list of invite codes")
    parser.add_argument('--prefix', '-x', help="username prefix for all load test accounts. Default: load", default="load")
    parser.add_argument('--password', '-p', help="password for all load test accounts. No default here.", required=True)
    parser.add_argument('--start', '-s', help="account number to start sequence. Like: prefix1, prefix2, ... Default: 1", default=1, type=int)
    args = parser.parse_args()
    invites = raw_input().split()
    start = args.start
    while invites:
        consume_invites(invites, args.prefix, start, args.password)
        invites = raw_input().split()
        start += 1
