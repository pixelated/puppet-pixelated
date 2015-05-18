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
            'tag_trash': 'li#tag-trash'
        }
        super(TagList, self).__init__(context, timeout)

    def go_to_trash(self):
        self._trash_tag().click()

    def _trash_tag(self):
        return self._find_element_by_locator(self._locators['tag_trash'])
