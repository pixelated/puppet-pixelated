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
from selenium.webdriver.common.by import By

from login_page import LoginPage


class LeapLoginPage(LoginPage):
    def __init__(self, context, timeout=10):
        super(LeapLoginPage, self).__init__(context, timeout)
        self._locators = {
            'username': 'input#srp_username',
            'password': 'input#srp_password',
            'login_button': 'button[type=submit]',
        }

    def destroy_account(self, user_id):
        current_url = self.context.browser.current_url
        self.context.browser.get(current_url + '/edit')
        delete_button_selector = 'a[href="/users/' + user_id + '"][data-method=delete]'
        self.wait_until_element_is_visible_by_locator((By.CSS_SELECTOR, delete_button_selector))
        self._find_elements_by_css_locator(delete_button_selector)[0].click()
