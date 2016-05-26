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
from page_objects import LeapLoginPage

from selenium import webdriver
from steps.common import *
from steps import behave_testuser, behave_password
from steps import signup_url

LEAP_HOME_FOLDER='/var/lib/pixelated/.leap/'

def before_feature(context, feature):
    set_browser(context)
    if 'account' == feature.name and 'staging' in feature.tags:
        create_behave_user(context)
    # if 'staging' in feature.tags:
    #     set_browser(context)


def after_step(context, step):
    screenshot_filename = '{step_name}.png'

    if step.status == 'failed':
        take_screenshot(context, screenshot_filename.format(step_name=step.name))
        log_browser_console(context, step)
        save_page_source(context, step)


def after_scenario(context, scenario):
    context.browser.delete_all_cookies()


def after_feature(context, feature):
    # if 'staging' in feature.tags:
    context.browser.quit()

def after_all(context):
    set_browser(context)
    _delete_user(context, behave_testuser(), behave_password())
    context.browser.quit()


def _delete_user(context, username, password):
    buffer = BytesIO()
    c = pycurl.Curl()
    c.setopt(c.WRITEDATA, buffer)
    c.setopt(c.URL, '127.0.0.1:5984/identities/_all_docs?include_docs=true')
    c.setopt(c.NETRC,1)
    c.setopt(c.NETRC_FILE,'/etc/couchdb/couchdb.netrc')
    c.perform()
    c.close()
    for row in json.loads(buffer.getvalue())['rows']:
        address=row.get('doc').get('address')
        if (address=='behave-testuser@unstable.pixelated-project.org'):
            id=row.get('id')
            url='http://127.0.0.1:5984/user-%s' % id
            c = pycurl.Curl()
            c.setopt(c.WRITEDATA, buffer)
            c.setopt(c.URL, url)
            c.setopt(c.CUSTOMREQUEST, 'DELETE')
            c.setopt(c.NETRC,1)
            c.setopt(c.NETRC_FILE,'/etc/couchdb/couchdb.netrc')
            c.perform()
            c.close()

def save_page_source(context, step):
    page_source_filename = '{step_name}.html'
    with open(page_source_filename.format(step_name=step.name), 'w') as page_source:
        page_source.write(context.browser.page_source)


def log_browser_console(context, step):
    console_log_filename = '{step_name}.log'
    with open(console_log_filename.format(step_name=step.name), 'w') as console_log_file:
        line = '{time} {level}: {message}\n'
        console_log_file.writelines(
            [line.format(time=x['timestamp'], level=x['level'], message=x['message']) for x in context.browser.get_log('browser')]
        )


def take_screenshot(context, filename):
    context.browser.save_screenshot(filename)


def set_browser(context):
    # context.browser = webdriver.Firefox()
    # context.browser = webdriver.Chrome()
    context.browser = webdriver.PhantomJS(service_args=['--ignore-ssl-errors=yes'])
    context.browser.set_window_size(1280, 1024)
    context.browser.implicitly_wait(10)
    context.browser.set_page_load_timeout(60)


def create_behave_user(context):
    username = behave_testuser()
    password = behave_password()

    context.browser.get(signup_url())
    signup_page = SignUpPage(context)
    signup_page.wait_until_element_is_visible_by_locator((By.CSS_SELECTOR, 'input#srp_username'))
    signup_page.enter_username(username)
    signup_page.enter_password(password)
    signup_page.enter_password_confirmation(password)
    signup_page.enter_invite_code(get_invite_code())
    signup_page.click_signup_button()
    # context.browser.quit()
