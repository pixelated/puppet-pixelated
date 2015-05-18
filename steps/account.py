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

import ConfigParser
from behave import *
from common import *

import os
import time


config = ConfigParser.ConfigParser()
current_dir = os.path.dirname(os.path.abspath(__file__))
config_path = os.path.join(current_dir, '..', 'config.cfg')
config.read(config_path)
dispatcher_address = config.get('staging', 'dispatcher_address')

@when(u'I visit the dispatcher')
def step_impl(context):
    context.browser.get('%s:8080/auth/login' % dispatcher_address)

@given(u'I visit the dispatcher')
def step_impl(context):
    context.browser.get('%s:8080/' % dispatcher_address)

@then(u'I should see a login button')
def step_impl(context):
    context.browser.find_element_by_name('login')

@when(u'I login')
def step_impl(context):
    wait_until_element_is_visible_by_locator(context, (By.ID, 'email'))
    fill_by_css_selector(context, 'input#email', random_username())
    fill_by_css_selector(context, 'input#password', random_password())
    context.browser.find_element_by_name("login").click()

@then(u'I see the inbox')
def step_impl(context):
        # phantomjs can not deal with the interstitial. We need to load the
        # website manually after the user-agent has started
        time.sleep(30)
        context.browser.get('%s:8080/' % dispatcher_address)
        # import pdb;pdb.set_trace()
        wait_until_element_is_visible_by_locator(context, (By.ID, 'tag-inbox'))
        # pdb.set_trace()

@when(u'I logout')
def step_impl(context):
    context.browser.get('%s:8080/auth/logout' % dispatcher_address)

@when(u'I visit the signup-page')
def step_impl(context):
    context.browser.get('%s/signup' % dispatcher_address)

@then(u'I should see a signup button')
def step_impl(context):
    context.browser.find_element_by_name('button')

@when(u'I register')
def step_impl(context):
    wait_until_element_is_visible_by_locator(context, (By.CSS_SELECTOR, 'input#srp_username'))
    fill_by_css_selector(context, 'input#srp_username', random_username())
    fill_by_css_selector(context, 'input#srp_password', random_password())
    fill_by_css_selector(context, 'input#srp_password_confirmation', random_password())
    context.browser.find_element_by_name("button").click()

@then(u'I see the control-panel')
def step_impl(context):
    find_element_containing_text(context,'user control panel')
