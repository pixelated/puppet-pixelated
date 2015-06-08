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
from common import *

from ..page_objects import TagList
from ..page_objects import MailList


def click_first_element_with_class(context, classname):
    elements = context.browser.find_elements_by_class_name(classname)
    elements[0].click()


def is_side_nav_expanded(context):
    e = context.browser.find_elements_by_class_name('content')[0].get_attribute('class').count(u'move-right') == 1
    return e


def expand_side_nav(context):
    if is_side_nav_expanded(context):
        return

    toggle = context.browser.find_elements_by_class_name('side-nav-toggle')[0]
    toggle.click()


@when('I select the tag \'{mailbox}\'')
def impl(context, mailbox):
    expand_side_nav(context)
    tag_list = TagList(context)

    tag_list.go_to_mailbox(mailbox)

    mail_list = MailList(context)
    mail_list.is_mailbox_loaded(context,mailbox)


