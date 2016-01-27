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
from behave import then
from ..page_objects import PixelatedPage
from ..page_objects import MailList
from ..page_objects import MailListActions




@then('I see the email on the mail list')
def impl(context):
    pixelated_page = PixelatedPage(context)
    pixelated_page.is_mail_on_list(context.pixelated_email, pixelated_page.random_subject(), 240)


#FROM USER AGENT REPO
from selenium.common.exceptions import NoSuchElementException
from time import sleep

def find_current_mail(context):
    return context.browser.find_element_by_id(context.current_mail_id)


def check_current_mail_is_visible(context):
    find_current_mail(context)


def open_current_mail(context):
    sleep(2)
    e = find_current_mail(context)
    e.click()


@then('I see that mail under the \'{tag}\' tag')
def impl(context, tag):
    context.execute_steps("when I select the tag '%s'" % tag)
    context.execute_steps(u'When I open the first mail in the mail list')


@when('I open that mail')
def impl(context):
    sleep(3)
    find_current_mail(context).click()


@when('I open the first mail in the mail list')
def impl(context):
    # maillist = MailList(context)
    context.current_mail_id = context.browser.find_element_by_css_selector("li[id^='mail']").get_attribute("id")
    context.browser.find_element_by_css_selector("li[id^='mail'] a").click()
    sleep(5)


@when('I open the first mail in the \'{tag}\'')
def impl(context, tag):
    context.execute_steps(u"When I select the tag '%s'" % tag)
    context.execute_steps(u'When I open the first mail in the mail list')


@when('I open the mail I previously tagged')
def impl(context):
    open_current_mail(context)


@then('I see the mail I sent')
def impl(context):
    src = context.browser.page_source
    assert context.reply_subject in src


@then('the deleted mail is there')
def impl(context):
    find_current_mail(context)


@given('I have mails')
def impl(context):
    mail_list = MailList(context)
    mails = mail_list.is_there_emails()
    assert len(mails) > 0


@when('I mark the first unread email as read')
def impl(context):
    mail_list = MailList(context)
    mails = mail_list.get_all_emails()

    for mail in mails:
        if 'status-read' not in mail.get_attribute('class'):
            mail.find_element_by_tag_name('input').click()
            context.browser.find_element_by_id('mark-selected-as-read').click()
            context.current_mail_id = mail.get_attribute('id')
            break
    sleep(5)
    assert 'status-read' in context.browser.find_element_by_id(context.current_mail_id).get_attribute('class')


@when('I delete the email')
def impl(context):
    maillist = MailList(context)
    def last_email():
        return maillist.wait_until_element_is_visible_by_locator((By.CSS_SELECTOR, '#mail-list li'))
    import pdb; pdb.set_trace()
    context.current_mail_id = last_email().get_attribute('id')
    last_email().find_element_by_tag_name('input').click()
    maillist._find_element_by_id('delete-selected').click()
    assert context.current_mail_id != maillist._find_elements_by_css_locator('#mail-list li span a')[0]


@when('I check all emails')
def impl(context):
    maillist_action = MailListActions(context)
    maillist_action.select_all_mails()


@when('I delete them permanently')
def impl(context):
    maillist_actions = MailListActions(context)
    maillist_actions.delete_selected_mails()
    maillist_actions._find_element_by_id('delete-selected').click()


@then('I should not see any email')
def impl(context):
    try:
        context.browser.find_element(By.CSS_SELECTOR, '#mail-list li span a')
    except NoSuchElementException:
        assert True
    except:
        assert False

