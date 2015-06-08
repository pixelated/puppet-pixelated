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
from selenium.webdriver.common.keys import Keys
from common import *

from ..page_objects import ComposeBox
from ..page_objects import MailList
from ..page_objects import MailListActions
from ..page_objects import MailPage
from ..page_objects import Notification


@then('I see that the subject reads \'{subject_expected}\'')
def impl(context, subject_expected):
    compose_box = ComposeBox(context)
    subject_read = compose_box.get_reply_subject().text
    assert subject_read == subject_expected


@then('I see that the body reads \'{body_expected}\'')
def impl(context, body_expected):
    mail_page = MailPage(context)
    body_read = mail_page.get_body().text
    assert body_read == body_expected


@then('that email has the \'{tag}\' tag')
def impl(context, tag):
    mail_page = MailPage(context)
    elements = mail_page.get_tags()
    tags = [e.text for e in elements]
    assert tag in tags


@when('I add the tag \'{tag}\' to that mail')
def impl(context, tag):
    mail_page = MailPage(context)
    mail_page.add_tag(tag)


@when('I reply to it')
def impl(context):
    mail_page = MailPage(context)
    mail_page.reply_mail()


@when('I try to delete the first mail')
def impl(context):
    context.execute_steps(u"When I open the first mail in the mail list")
    mail_page = MailPage(context)
    mail_page.delete_mail()

    notification = Notification(context)
    notification.wait_for_notification("message_deleted")

@when('I choose to forward this mail')
def impl(context):
    mail_page = MailPage(context)
    mail_page.forward_mail()

@when('I forward this mail')
def impl(context):
    compose_box = ComposeBox(context)
    compose_box.send_mail()


@when('I remove all tags')
def impl(context):
    mail_page = MailPage(context)
    mail_page.remove_tags()


@when('I choose to trash')
def impl(context):
    mail_list = MailList(context)
    mail_list.mark_nth_checkbox(1)
    maillist_actions = MailListActions(context)
    maillist_actions.delete_selected_mails()


@then('I see the mail has a cc and a bcc recipient')
def impl(context):
    mail_page = MailPage(context)
    assert mail_page.mail_has_cc_and_bcc() == True

