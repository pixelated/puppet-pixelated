#
# Copyright (c) 2014 ThoughtWorks, Inc.
#
# Pixelated is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Pixelated is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Pixelated. If not, see <http://www.gnu.org/licenses/>.
import os
import subprocess

from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait
from email.mime.text import MIMEText
from steps import behave_email, hostname

import string
import random
import smtplib


MAX_WAIT_IN_S = 120


def random_username():
    if 'randomname' not in globals():
        global randomname
        randomname=''.join(random.choice(string.lowercase) for i in range(16))
    return randomname


def random_password():
    if 'randompassword' not in globals():
        global randompassword
        randompassword=''.join(random.choice(string.lowercase) for i in range(16))
    return randompassword


def get_invite_code():
    if os.environ.get('INVITE_CODE_ENABLED') == 'true':
        os.environ['RAILS_ENV'] = 'production'
        return subprocess.check_output('bundle exec rake generate_invites[1]'.split(), cwd='/srv/leap/webapp').strip()


def random_subject():
    if 'randomsubject' not in globals():
        global randomsubject
        randomsubject=''.join(random.choice(string.lowercase) for i in range(16))
    return randomsubject


def wait_long_until_element_is_visible_by_locator(context, locator_tuple):
    wait_emails_for = 600
    wait = WebDriverWait(context.browser, wait_emails_for)
    wait.until(EC.visibility_of_element_located(locator_tuple))
    by, value = locator_tuple
    return context.browser.find_element(by, value)


def save_source(context, filename='/tmp/source.html'):
    with open(filename, 'w') as out:
        out.write(context.browser.page_source.encode('utf8'))


def send_external_email(subject, body):
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = behave_email()
    msg['To'] = behave_email()

    s = smtplib.SMTP(hostname)
    s.sendmail(behave_email(), [behave_email()], msg.as_string())
    s.quit()


def open_email(context, subject):
    locator = '//ul[@id="mail-list"]//*[contains(.,"%s")]/parent::a' % subject
    wait_long_until_element_is_visible_by_locator(context, (By.XPATH, locator)).click()








