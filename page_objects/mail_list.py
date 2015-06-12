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
from selenium.common.exceptions import TimeoutException
from time import sleep

class MailList(BasePageObject):
    def __init__(self, context, timeout=10):
        self._locators = {
            'mail_items': '//a[contains(., "{sender}") and contains(., "{subject}")]',
            'mailbox_mails': "#mail-list li span a[href*='{mailbox}']",
            'all_mails': '#mail-list li',
            'checkboxes':  '#mail-view #view-more-actions'
        }
        super(MailList, self).__init__(context, timeout)

    def is_mail_on_list(self, sender, subject, timeout=None):
        try:
            self.select_mail(sender, subject, timeout)
            return True
        except TimeoutException:
            return False

    def is_mail_not_on_the_list(self, sender, subject):
        try:
            xpath = self._locators['mail_items'].format(
                sender=sender,
                subject=subject)
            self._wait_element_to_be_removed_by_xpath(xpath)
            return True
        except TimeoutException:
            return False

    def is_there_emails(self):
        return self.wait_until_elements_are_visible_by_css_locator(self._locators['all_mails'])

    def is_mailbox_loaded(self,context, mailbox):
        self.wait_until_elements_are_visible_by_css_locator(self._locators['mailbox_mails'].format(mailbox))

    def select_mail(self, sender, subject, timeout=180):
        xpath = self._locators['mail_items'].format(sender=sender, subject=subject)
        self._find_element_by_xpath( xpath, timeout=timeout).click()

    def mark_nth_checkbox(self, position):
        checkboxes = self._find_elements_by_css_locator(self._locators['checkboxes'])
        checkboxes[position].click()


