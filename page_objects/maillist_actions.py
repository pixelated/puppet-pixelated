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
from selenium.webdriver.common.keys import Keys

from base_page_object import BasePageObject


class MailListActions(BasePageObject):
    def __init__(self, context, timeout=10):
        self._locators = {
            'compose_mail_button': 'div#compose-mails-trigger',
            'delete_selected_button': 'input#delete-selected',
            'delete_successful_message': '//span[contains("Your messages were moved to trash!")]',
            'search': '#search-trigger input[type="search"]',
            'select_all_mails': '#toggle-check-all-emails'
        }
        super(MailListActions, self).__init__(context, timeout)

    def open_compose_box(self):
        self._compose_mail_button().click()

    def delete_selected_mails(self):
        self._delete_selected_button().click()

    def select_all_mails(self):
        self._find_elements_by_css_locator(self._locators['select_all_mails']).click()

    def do_search(self, search_term):
        search_box = self._find_elements_by_css_locator(self._locators['search'])
        search_box.send_keys(search_box).send_keys(Keys.ENTER)

    def _compose_mail_button(self):
        return self._find_element_by_css_locator(self._locators['compose_mail_button'])

    def _delete_selected_button(self):
        return self._find_element_by_css_locator(self._locators['delete_selected_button'])


