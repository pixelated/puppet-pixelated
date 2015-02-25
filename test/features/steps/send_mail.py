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

@when(u'I compose a mail')
def step_impl(context):
    wait_until_element_is_visible_by_locator(context, (By.ID, 'compose-trigger'))
    context.browser.find_element_by_id("compose-trigger").click()
    fill_by_xpath(context, '//*[@id="subject"]', 'Totally cool subject for testing this totally cool app')
    fill_by_xpath(context, '//*[@id="text-box"]', 'Hi, \n this is an email. To find this email, I add this strange string here:\n eisheeneejaih7eiw7heiLah')
    fill_by_xpath(context, '//input[@class="tt-input"]', 'behave-testuser@staging.pixelated-project.org')

@when(u'I press the send button')
def step_impl(context):
    context.browser.find_element_by_id("send-button").click()

@when(u'I see that the mail was sent')
def step_impl(context):
    wait_until_element_is_visible_by_locator(context, (By.XPATH, '//*[contains(.,"Your message was sent!")]'))

@then(u'I see the new mail in the inbox')
def step_impl(context):
    wait_long_until_element_is_visible_by_locator(context, (By.XPATH, '//ul[@id="mail-list"]//*[contains(.,"Totally cool subject for testing this totally cool app")]'))

