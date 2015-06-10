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

from page_objects import SignUpPage

from selenium import webdriver
from steps.common import *
import os

config = ConfigParser.ConfigParser()
current_dir = os.path.dirname(os.path.abspath(__file__))
config_path = os.path.join(current_dir, 'config.cfg')
config.read(config_path)

def before_scenario(context, scenario):
    feature = scenario.feature

    if 'try' in feature.tags:
        user_agent_address = config.get('try', 'user_agent_address')
        set_browser(context)
        context.browser.get(user_agent_address)


def after_scenario(context, scenario):
    feature = scenario.feature

    if 'try' in feature.tags:
        context.browser.quit()

def before_feature(context, feature):
    if 'account' == feature.name and 'staging' in feature.tags:
        create_behave_user(context)
    if 'staging' in feature.tags:
        set_browser(context)


def after_feature(context, feature):
    if 'staging' in feature.tags:
        context.browser.quit()


def after_step(context, step):
    screenshot_filename = '{step_name}.png'

    if step.status == 'failed':
        take_screenshot(context, screenshot_filename.format(step_name=step.name))
        log_browser_console(context, step)
        save_page_source(context, step)
        context.browser.quit()


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
    context.browser = webdriver.PhantomJS(service_args=['--ignore-ssl-errors=yes'])
    context.browser.set_window_size(1280, 1024)
    context.browser.implicitly_wait(10)
    context.browser.set_page_load_timeout(60)

def create_behave_user(context):
    set_browser(context)
    username = config.get('staging', 'behave_testuser')
    password = config.get('staging', 'behave_password')

    context.browser.get('https://staging.pixelated-project.org/signup')
    signup_page = SignUpPage(context)
    signup_page.wait_until_element_is_visible_by_locator((By.CSS_SELECTOR, 'input#srp_username'))
    signup_page.enter_username(username)
    signup_page.enter_password(password)
    signup_page.enter_password_confirmation(password)
    signup_page.click_signup_button()
    context.browser.quit()