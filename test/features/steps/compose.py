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

from behave import when

from ..page_objects import ComposeBox
from ..page_objects import MailListActions

@when("I compose a message to '{recipient}'")
def impl(context, recipient):
    compose_box = ComposeBox(context)
    maillist_actions = MailListActions(context)
    maillist_actions.open_compose_box()

    compose_box.enter_subject("Pixelated rocks!")
    compose_box.enter_body("You should definitely use it. Cheers, User.")
    compose_box.enter_recipients(recipient)
    compose_box.save_draft()


@when('I send it')
def send_impl(context):
    compose_box = ComposeBox(context)
    compose_box.send_mail()




