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
import os
from page_objects import SignUpPage
from selenium import webdriver
from steps.common import RandomUser
from steps import behave_testuser
import subprocess


def before_all(context):
    set_browser(context)
    context.random_user = RandomUser


def after_step(context, step):
    screenshot_filename = 'test_{step_name}.png'
    screenshot_path = os.path.join('/var/log/pixelated', screenshot_filename)

    if step.status == 'failed':
        take_screenshot(context,
                        screenshot_path.format(step_name=step.name))
        log_browser_console(context, step)
        save_page_source(context, step)


def after_scenario(context, scenario):
    context.browser.delete_all_cookies()


def after_all(context):
    _delete_user(context, behave_testuser())
    _delete_user(context, context.random_user.username)
    if hasattr(context, 'browser'):
        context.browser.quit()


def _delete_user(context, username):
    try:
        subprocess.check_call(
            ['./destroy-user-db', '--destroy-identities',
             '--username', username], cwd='/srv/leap/couchdb/scripts')
    except Exception as e:
        print(e.returncode, e.output)


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


def take_screenshot(context, path):
    print('Screenshot saved to: {path}'.format(path=path))
    context.browser.save_screenshot(path)


def set_browser(context):
    # context.browser = webdriver.Firefox()
    #context.browser = webdriver.Chrome()
    context.browser = webdriver.PhantomJS(service_args=['--ignore-ssl-errors=yes'])
    context.browser.set_window_size(1280, 1024)
    context.browser.implicitly_wait(10)
    context.browser.set_page_load_timeout(60)
