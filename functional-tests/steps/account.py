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
import time

from behave import *

from ..page_objects import LoginPage
from ..page_objects import SignUpPage
from ..page_objects import ControlPanelPage
from ..page_objects import TagList
from common import *

config = ConfigParser.ConfigParser()
current_dir = os.path.dirname(os.path.abspath(__file__))
config_path = os.path.join(current_dir, '..', 'config.cfg')
config.read(config_path)
dispatcher_address = config.get('staging', 'dispatcher_address')

@when(u'I visit the dispatcher')
def step_impl(context):
    context.browser.get('%s:8080/auth/login' % dispatcher_address)


@then(u'I should see a login button')
def step_impl(context):
    context.browser.find_element_by_name('login')


@when(u'I login')
def step_impl(context):
    login_page = LoginPage(context)
    login_page.enter_username(random_username()).enter_password(random_password()).login()
    login_page.wait_interstitial_page()


@then(u'I see the inbox')
def step_impl(context):
        # phantomjs can not deal with the interstitial. We need to load the
        # website manually after the user-agent has started
        time.sleep(30)
        taglist = TagList(context)
        taglist.is_pixelated_loaded()
        # wait_until_element_is_visible_by_locator(context, (By.ID, 'tag-inbox'))


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
    signup_page = SignUpPage(context)
    signup_page.enter_username(random_username())
    signup_page.enter_password(random_password())
    signup_page.enter_password_confirmation(random_password())
    signup_page.click_signup_button()


@then(u'I see the control-panel')
def step_impl(context):
    controlpanel_page = ControlPanelPage(context)
    controlpanel_page.is_control_panel_home()
