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

import time

from selenium.webdriver.common.by import By

from behave import *
from common import *

@given(u'I login as behave-testuser')
def step_impl(context):
    context.browser.get('https://staging.pixelated-project.org:8080/auth/login')
    wait_until_element_is_visible_by_locator(context, (By.ID, 'email'))
    fill_by_xpath(context, '//*[@id="email"]', 'behave-testuser')
    fill_by_xpath(context, '//*[@id="password"]', 'Eido6aeg3za9ooNiekiemahm')
    context.browser.find_element_by_name("login").click()

@given(u'I send an unencrypted email')
def step_impl(context):
    send_external_email('unencrypted email %s' %random_subject(), 'some body')

@given(u'I send an email encrypted to someone else')
def step_impl(context):
    send_external_email('undecryptable email %s' %random_subject(), encrypted_body())

@when(u'I compose a mail')
def step_impl(context):
    wait_until_element_is_visible_by_locator(context, (By.ID, 'compose-mails-trigger'))
    context.browser.find_element_by_id("compose-mails-trigger").click()
    fill_by_xpath(context, '//*[@id="subject"]', random_subject())
    fill_by_xpath(context, '//*[@id="text-box"]', 'Hi, \n this is an email. To find this email, I add this strange string here:\n eisheeneejaih7eiw7heiLah')
    fill_by_xpath(context, '//input[@class="tt-input"]', 'behave-testuser@staging.pixelated-project.org')

@when(u'I press the send button')
def step_impl(context):
    context.browser.find_element_by_id("send-button").click()

@when(u'I see that the mail was sent')
def step_impl(context):
    wait_until_element_is_visible_by_locator(context, (By.XPATH, '//*[contains(.,"Your message was sent!")]'))

@when(u'I open the email')
def step_impl(context):
    open_email(context, random_subject())

@when(u'I open the undecryptable email')
def step_impl(context):
    open_email(context, 'undecryptable email %s' % random_subject())

@when(u'I open the unencrypted email')
def step_impl(context):
    open_email(context, 'unencrypted email %s' % random_subject())

@then(u'I see the new mail in the inbox')
def step_impl(context):
    xpath_string= '//ul[@id="mail-list"]//*[contains(.,"%s")]' % random_subject()
    wait_long_until_element_is_visible_by_locator(context, (By.XPATH,xpath_string))

@then(u'I see a encrypted flag')
def step_impl(context):
    wait_until_element_is_visible_by_locator(context,(By.CSS_SELECTOR, '.encrypted.encryption-valid'))

@then(u'I see a unencrypted email flag')
def step_impl(context):
    wait_until_element_is_visible_by_locator(context,(By.CSS_SELECTOR, '.not-encrypted'))
    
@then(u'I see a undecryptable flag')
def step_impl(context):
    wait_until_element_is_visible_by_locator(context,(By.CSS_SELECTOR, '.encrypted.encryption-error'))

def encrypted_body():
    return """
-----BEGIN PGP MESSAGE-----
Comment: GPGTools - https://gpgtools.org

hQIMA8Aza4SMPrUXARAAsiIM/+InP8FP77iI/Kuhlaj1JHkjomGdm3X/fc7W498e
njbLt58cLwiGdNJWEKCBWP8McjyKevA5b9CaE94qJJA2OHEPo2yG6mL+SbbhvHFw
X+815CwxeT/VsqJksRXxl7Y337t9PgniWvpnlAhmtkh4S8CskqQJjZCFmC0v2s9r
XuJv/XEgReG2xX7SktjMwVYFRb5ghpbz42JyP8ahUGOlyIpYVwRp4tzsYWhCJH90
WPKqPwLBatJ0qHzYVky6KpsnjFdwTLjy9NM5yw1xPkuuUFjjB7pKZTCTdtfkAyX9
qcH0iUdhmlzUhm0BIJpyFW4gfh6+mWTe0oWa+Lf3NIiJEmeNl8Z9nAKVcfjwgVOS
nrjaTM3lOh15MwBblOK5B0CM5YyEhJ6NG0gITM+dt+gItpbUi53QU/oRZJ6mCvNB
J/XX9lYua+FcSrgXygcGU0Lyx1vOwRjm4/BsJGXmYZ2dow0moJ4IVDRlcecpYzaz
j7M0fzajCmeS+JVaqrBVxecFE4LIw2cFbT27pYScO18Id1c3b7n/6TxJjyMYAgNa
cUeI6yCx1w6roGSkG53L3MQPHfjMNSHhRdG0PeprBVg2G4n2Wazfl3n9mqb0Mk4K
YyVbN9+LY+R8e3obfVGZsZAp5nHlSR/mhuq0EfS1S9a18XMSIIVv8p90su/SvD3S
TQE9zqA3EjY4OzrNe+FKVpLFjCo5VLxuCZdaCVbjuEhDk7i/X06T3dqPtqlvIErW
R2zZzupoH5OfjBazUB0ZqkRBZTO/VAAmVr8DCk+e
=htJr
-----END PGP MESSAGE-----
"""
