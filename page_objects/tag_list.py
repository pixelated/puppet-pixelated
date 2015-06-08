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


class TagList(BasePageObject):
    def __init__(self, context, timeout=10):
        self._locators = {
            'inbox': 'li#tag-inbox',
            'trash': 'li#tag-trash',
            'draft': 'li#tag-draft',
            'sent': 'li#tag-sent'
        }
        super(TagList, self).__init__(context, timeout)

    def go_to_trash(self):
        self._trash_tag().click()

    def go_to_drafts(self):
        self._draft_tag().click()

    def go_to_inbox(self):
        self._inbox_tag().click()

    def go_to_sent(self):
        self._sent_tag().click()

    def go_to_mailbox(self, mailbox):
        self._go_to_mailbox(mailbox).click()

    def _go_to_mailbox(self, mailbox):
        return self._find_element_by_css_locator(self._locators[mailbox])

    def _trash_tag(self):
        return self._find_element_by_css_locator(self._locators['trash'])

    def _draft_tag(self):
        return self._find_element_by_css_locator(self._locators['draft'])

    def _inbox_tag(self):
        return self._find_element_by_css_locator(self._locators['inbox'])

    def _inbox_tag(self):
        return self._find_element_by_css_locator(self._locators['sent'])

    def is_pixelated_loaded(self):
        self.wait_until_element_is_visible_by_locator(self._locators['inbox'])
