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
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait
from email.mime.text import MIMEText

import ConfigParser
import os
import string
import random
import smtplib


config = ConfigParser.ConfigParser()
current_dir = os.path.dirname(os.path.abspath(__file__))
config_path = os.path.join(current_dir, '..', 'config.cfg')
config.read(config_path)

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


def random_subject():
    if 'randomsubject' not in globals():
        global randomsubject
        randomsubject=''.join(random.choice(string.lowercase) for i in range(16))
    return randomsubject


def fill_by_xpath(context, xpath, text):
    field = context.browser.find_element_by_xpath(xpath)
    field.send_keys(text)


def take_screenshot(context, filename):
    context.browser.save_screenshot(filename)


def dump_source_to(context, filename):
    with open(filename, 'w') as out:
        out.write(context.browser.page_source.encode('utf8'))


def wait_until_element_is_visible_by_locator(context, locator_tuple):
    wait = WebDriverWait(context.browser, MAX_WAIT_IN_S)
    wait.until(EC.visibility_of_element_located(locator_tuple))
    by, value = locator_tuple
    return context.browser.find_element(by, value)


def wait_long_until_element_is_visible_by_locator(context, locator_tuple):
    wait_emails_for = 300
    wait = WebDriverWait(context.browser, wait_emails_for)
    wait.until(EC.visibility_of_element_located(locator_tuple))
    by, value = locator_tuple
    return context.browser.find_element(by, value)



def find_element_by_xpath(context, xpath):
    return wait_until_element_is_visible_by_locator(context, (By.XPATH, xpath))


def find_element_by_id(context, id):
    return wait_until_element_is_visible_by_locator(context, (By.ID, id))


def find_element_by_css_selector(context, css_selector):
    return wait_until_element_is_visible_by_locator(context, (By.CSS_SELECTOR, css_selector))


def find_element_containing_text(context, text, element_type='*'):
    return find_element_by_xpath(context, "//%s[contains(.,'%s')]" % (element_type, text))


def element_should_have_content(context, css_selector, content):
    e = find_element_by_css_selector(context, css_selector)
    assert e.text == content


def click_button(context, title, element='button'):
    button = find_element_containing_text(context, title, element_type=element)
    button.click()

def save_source(context):
    with open('/tmp/source.html', 'w') as out:
        out.write(context.browser.page_source.encode('utf8'))


def send_external_email(subject, body):
    behave_email = config.get('staging', 'behave_email')
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = behave_email
    msg['To'] = behave_email

    s = smtplib.SMTP('staging.pixelated-project.org')
    s.sendmail(behave_email, [behave_email], msg.as_string())
    s.quit()


def open_email(context, subject):
    locator = '//ul[@id="mail-list"]//*[contains(.,"%s")]/parent::a' % subject
    wait_long_until_element_is_visible_by_locator(context, (By.XPATH, locator)).click()


def fill_by_css_selector(context, css_selector, text):
    field = context.browser.find_element_by_css_selector(css_selector)
    field.send_keys(text)


def fill_by_xpath(context, xpath, text):
    field = context.browser.find_element_by_xpath(xpath)
    field.send_keys(text)



