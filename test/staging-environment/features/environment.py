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
import logging
import time

from selenium import webdriver
from selenium.webdriver.common.by import By
from steps.common import *


def before_all(context):
    # context.browser = webdriver.Firefox()
    context.browser = webdriver.PhantomJS(service_args=['--ignore-ssl-errors=yes'])
    context.browser.set_window_size(1280, 1024)
    context.browser.implicitly_wait(5)
    context.browser.set_page_load_timeout(60)  # wait for data
    logging.disable('INFO')

    context.browser.get('https://staging.pixelated-project.org/signup')
    wait_until_element_is_visible_by_locator(context, (By.CSS_SELECTOR, 'input#srp_username'))
    fill_by_css_selector(context, 'input#srp_username', 'behave-testuser')
    fill_by_css_selector(context, 'input#srp_password','Eido6aeg3za9ooNiekiemahm')
    fill_by_css_selector(context, 'input#srp_password_confirmation','Eido6aeg3za9ooNiekiemahm')
    context.browser.find_element_by_name("button").click()

    context.browser.quit()
#
def before_feature(context, feature):
    # context.browser = webdriver.Firefox()
    context.browser = webdriver.PhantomJS(service_args=['--ignore-ssl-errors=yes'])
    context.browser.set_window_size(1280, 1024)
    context.browser.implicitly_wait(10)
    context.browser.set_page_load_timeout(60)  # wait for data

def after_feature(context, feature):
    context.browser.quit()


def after_step(context, step):
    screenshot_filename = "{step_name}.png"

    if step.status == "failed":
        take_screenshot(context, screenshot_filename.format(step_name=step.name))
        log_browser_console(context, step)
        save_page_source(context, step)



def save_page_source(context, step):
    page_source_filename = "{step_name}.html"
    with open(page_source_filename.format(step_name=step.name), "w") as page_source:
        page_source.write(context.browser.page_source)


def log_browser_console(context, step):
    console_log_filename = "{step_name}.log"
    with open(console_log_filename.format(step_name=step.name), "w") as console_log_file:
        line = "{time} {level}: {message}\n"
        console_log_file.writelines(
            [line.format(time=x['timestamp'], level=x['level'], message=x['message']) for x in context.browser.get_log("browser")]
        )





