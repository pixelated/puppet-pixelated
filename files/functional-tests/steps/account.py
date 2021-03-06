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

from behave import *
from steps import login_url, logout_url, signup_url

from common import *
from ..page_objects import ControlPanelPage
from ..page_objects import LoginPage
from ..page_objects import SignUpPage
from ..page_objects import TagList


@when(u'I visit the user-agent')
def step_impl(context):
    context.browser.get(login_url())


@then(u'I should see a login button')
def step_impl(context):
    context.browser.find_element_by_css_selector('button[type=submit]')


@given(u'I\'m logged in')
@when(u'I login')
def step_impl(context):
    context.browser.get(login_url())
    login_page = LoginPage(context)
    login_page.enter_username(context.random_user.username).enter_password(context.random_user.password).login()
    login_page.wait_interstitial_page()


@then(u'I see the inbox')
def step_impl(context):
    # phantomjs can not deal with the interstitial. We need to load the
    # website manually after the user-agent has started
    time.sleep(30)
    taglist = TagList(context)
    taglist.is_pixelated_loaded()


@when(u'I logout')
def step_impl(context):
    logout_button = context.browser.find_element_by_css_selector('ul#logout')
    logout_button.click()


@when(u'I visit the signup-page')
def step_impl(context):
    context.browser.get(signup_url())


@then(u'I should see a signup button')
def step_impl(context):
    context.browser.find_element_by_name('button')


@when(u'I register')
def step_impl(context):
    signup_page = SignUpPage(context)
    signup_page.enter_username(context.random_user.username)
    signup_page.enter_password(context.random_user.password)
    signup_page.enter_password_confirmation(context.random_user.password)
    signup_page.enter_invite_code(get_invite_code())
    signup_page.click_signup_button()


@then(u'I see the control-panel')
def step_impl(context):
    controlpanel_page = ControlPanelPage(context)
    controlpanel_page.is_control_panel_home()
