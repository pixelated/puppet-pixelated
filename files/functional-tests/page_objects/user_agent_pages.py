#
# Copyright (c) 2015 ThoughtWorks, Inc.
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

from base_page_object import BasePageObject


class SignUpPage(BasePageObject):
    def __init__(self, context, timeout=10):
        self._locators = {
            'username': 'input#srp_username',
            'pswd': 'input#srp_password',
            'pswd_confirmation': 'input#srp_password_confirmation',
            'invite': 'input#srp_invite_code'
        }
        super(SignUpPage, self).__init__(context, timeout)

    def enter_username(self, username):
        self._fill_field('username', username)
        return self

    def enter_invite_code(self, invite_code):
        if invite_code:
            self._enter_invite_code(invite_code)
        return self

    def enter_password(self, password):
        self._fill_field('pswd', password)
        return self

    def enter_password_confirmation(self, password):
        self._fill_field('pswd_confirmation', password)
        return self

    def _enter_invite_code(self, invite_code):
        self._fill_field('invite', invite_code)
        return self

    def click_signup_button(self):
        self._signup_button().click()
        return self

    def _fill_field(self, locator_key, value):
        field = self._find_element_by_css_locator(self._locators[locator_key])
        field.send_keys(value)

    def _signup_button(self):
        return self.context.browser.find_element_by_name("button")


class ControlPanelPage(BasePageObject):
    def __init__(self, context, timeout=10):
        self._locators = {
            'home': "//h1[contains(.,'user control panel')]"
        }
        super(ControlPanelPage, self).__init__(context, timeout)

    def is_control_panel_home(self):
        self.context.browser.find_element_by_xpath(self._locators['home'])