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

import pycurl
import json
import shutil
from io import BytesIO

from page_objects import SignUpPage

from selenium import webdriver
from steps.common import *
from steps import behave_testuser, behave_password
from steps import signup_url

LEAP_HOME_FOLDER = '/var/lib/pixelated/.leap/'


def before_feature(context, feature):
    set_browser(context)
    if 'account' == feature.name and 'staging' in feature.tags:
        create_behave_user(context)
    # if 'staging' in feature.tags:
    #     set_browser(context)


def after_step(context, step):
    screenshot_filename = '{step_name}.png'

    if step.status == 'failed':
        take_screenshot(context,
                        screenshot_filename.format(step_name=step.name))
        log_browser_console(context, step)
        save_page_source(context, step)


def after_scenario(context, scenario):
    context.browser.delete_all_cookies()


def after_feature(context, feature):
    # if 'staging' in feature.tags:
    context.browser.quit()


def after_all(context):
    _delete_user(context, behave_testuser(), behave_password())


def _delete_user(context, username, password):
    username_buffer = BytesIO()
    c = pycurl.Curl()
    c.setopt(pycurl.WRITEDATA, username_buffer)
    c.setopt(pycurl.URL,
             '127.0.0.1:5984/identities/_all_docs?include_docs=true')
    c.setopt(pycurl.NETRC, 1)
    c.setopt(pycurl.NETRC_FILE, '/etc/couchdb/couchdb.netrc')
    c.perform()
    c.close()
    for row in json.loads(username_buffer.getvalue())['rows']:
        address = row.get('doc').get('address')
        if (isinstance(address, basestring) and
                address.startswith('behave-testuser')):
            id = row.get('doc').get('user_id')
            url = 'http://127.0.0.1:5984/user-%s' % id
            userdb_buffer = BytesIO()
            d = pycurl.Curl()
            d.setopt(pycurl.WRITEDATA, userdb_buffer)
            d.setopt(pycurl.URL, url)
            d.setopt(pycurl.POST, 1)
            d.setopt(pycurl.CUSTOMREQUEST, 'DELETE')
            d.setopt(pycurl.NETRC, 1)
            d.setopt(pycurl.NETRC_FILE, '/etc/couchdb/couchdb.netrc')
            d.perform()
            d.close()


def save_page_source(context, step):
    page_source_filename = '{step_name}.html'.format(step_name=step.name)
    with open(page_source_filename, 'w') as page_source:
        page_source.write(context.browser.page_source)


def log_browser_console(context, step):
    console_log_filename = '{step_name}.log'.format(step_name=step.name)
    with open(console_log_filename, 'w') as console_log_file:
        line = '{time} {level}: {message}\n'
        log_lines = []
        for log in context.browser.get_log('browser'):
            log_lines.append(line.format(time=log['timestamp'],
                                         level=log['level'],
                                         message=log['message']))
        console_log_file.writelines(log_lines)


def take_screenshot(context, filename):
    context.browser.save_screenshot(filename)


def set_browser(context):
    # context.browser = webdriver.Firefox()
    # context.browser = webdriver.Chrome()
    context.browser = webdriver.PhantomJS(
        service_args=['--ignore-ssl-errors=yes'])
    context.browser.set_window_size(1280, 1024)
    context.browser.implicitly_wait(10)
    context.browser.set_page_load_timeout(60)


def create_behave_user(context):
    username = behave_testuser()
    password = behave_password()

    context.browser.get(signup_url())
    signup_page = SignUpPage(context)
    signup_page.wait_until_element_is_visible_by_locator(
        (By.CSS_SELECTOR, 'input#srp_username'))
    signup_page.enter_username(username)
    signup_page.enter_password(password)
    signup_page.enter_password_confirmation(password)
    signup_page.enter_invite_code(get_invite_code())
    signup_page.click_signup_button()
    # context.browser.quit()
