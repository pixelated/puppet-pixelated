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
from time import sleep

from selenium.webdriver.common.keys import Keys
from common import *

from ..page_objects import MailListActions
from ..page_objects import MailList


@when('I search for a mail with the words "{search_term}"')
def impl(context, search_term):
    maillist_action = MailListActions(context)
    maillist_action.do_search(search_term)
    sleep(1)


@then('I see one or more mails in the search results')
def impl(context):
    maillist= MailList(context)
    assert maillist.is_there_emails()
