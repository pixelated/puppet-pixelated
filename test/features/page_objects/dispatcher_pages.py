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

from base_page_object import BasePageObject

class SignUpPage(BasePageObject):
    def __init__(self, context, timeout=10):
        self._locators = {
            'username': 'input#srp_username',
            'pswd': 'input#srp_password',
            'pswd_confirmation': 'input#srp_password_confirmation'
        }
        super(SignUpPage, self).__init__(context, timeout)

    def enter_username(self, username):
        self._username_field().send_keys(username)
        return self

    def enter_password(self, password):
        self._password_field().send_keys(password)
        return self

    def enter_password_confirmation(self, password):
        self._password_confirmation_field().send_keys(password)
        return self

    def click_signup_button(self):
        self._signup_button().click()
        return self

    def _username_field(self):
        return self._find_element_by_locator(self._locators['username'])

    def _password_field(self):
        return self._find_element_by_locator(self._locators['pswd'])

    def _password_confirmation_field(self):
        return self._find_element_by_locator(self._locators['pswd_confirmation'])

    def _signup_button(self):
        return self.context.browser.find_element_by_name("button")