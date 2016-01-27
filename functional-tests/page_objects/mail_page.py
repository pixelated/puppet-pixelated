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
from compose_box import ComposeBox

class MailPage(BasePageObject):
    def __init__(self, context, timeout=10):
        self._locators = {
            'encrypted_flag': '.encrypted.encryption-valid',
            'unencrypted_flag': '.not-encrypted',
            'undercryptable_flag': '.encrypted.encryption-error',
            'subject': '#mail-view .subject',
            'body': '#mail-view .bodyArea',
            'tags': '#mail-view .tagsArea .tag',
            'add_tag_button': '#new-tag-button',
            'add_tag_input': '#new-tag-input',
            'reply_button': 'Reply',
            'forward_button': 'button#forward-button',
            'cc': '.msg-header .cc',
            'bcc': '.msg-header .bcc',
            'delete': 'span#delete-button-top',
            'more_actions': '#mail-view #view-more-actions'
        }
        super(MailPage, self).__init__(context, timeout)

    def check_mail_flag(self, flag):
        self._find_element_by_css_locator(self._locators[flag])

    def get_subject(self):
        return self._find_element_by_css_locator(self._locators['subject'])

    def get_body(self):
        return self._find_element_by_css_locator(self._locators['body'])

    def get_tags(self):
        return self._find_elements_by_css_locator(self._locators['tags'])

    def add_tag(self, tag):
        # import pdb; pdb.set_trace()
        self._find_element_by_css_locator(self._locators['add_tag_button']).click()
        self._find_element_by_css_locator(self._locators['add_tag_input']).send_keys(tag + Keys.ENTER)

    def press_reply_button(self):
        self._find_element_containing_text(self._locators['reply_button'], 'button').click()

    def mail_has_cc_and_bcc(self):
        cc = self._find_element_by_css_locator(self._locators['cc']).text
        bcc = self._find_element_by_css_locator(self._locators['bcc']).text

        return (cc is not None) and (bcc is not None)

    def reply_mail(self):
        self.press_reply_button()
        compose_box = ComposeBox(self.context)
        self.context.reply_subject = compose_box.get_reply_subject()
        compose_box.send_mail()

    def forward_mail(self):
        self._find_elements_by_css_locator(self._locators['forward_button']).click()

    def remove_tags(self):
        tags = self._find_elements_by_css_locator(self._locators['tags'])
        for tag in tags:
            tag.click()

    def delete_mail(self):
        self._find_element_by_css_locator(self._locators['more_actions']).click()
        self._find_element_by_css_locator(self._locators['delete']).click()