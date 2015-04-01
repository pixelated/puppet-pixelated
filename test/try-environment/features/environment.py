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

from selenium import webdriver


def before_scenario(context, scenario):
    # context.browser = webdriver.Firefox()
    context.browser = webdriver.PhantomJS(service_args=['--ignore-ssl-errors=yes'])
    context.browser.set_window_size(1280, 1024)
    context.browser.implicitly_wait(5)
    context.browser.set_page_load_timeout(60)  # wait for data
    context.browser.get('https://try.pixelated-project.org:8080/')


def after_scenario(context, scenario):
    context.browser.quit()


def take_screenshot(context, filename='/tmp/screenshot.png'):
    context.browser.save_screenshot(filename)


def log_browser_console(context, step):
    console_log_filename = "{step_name}.log"
    with open(console_log_filename.format(step_name=step.name), "w") as console_log_file:
        line = "{time} {level}: {message}"
        console_log_file.writelines(
            [line.format(time=x['timestamp'], level=x['level'], message=x['message']) for x in context.browser.get_log("browser")]
        )


def save_page_source(context, step):
    page_source_filename = "{step_name}.html"
    with open(page_source_filename.format(step_name=step.name), "w") as page_source:
        page_source.write(context.browser.page_source)


def after_step(context, step):
    screenshot_filename = "{step_name}.png"

    if step.status == "failed":
        take_screenshot(context, screenshot_filename.format(step_name=step.name))
        log_browser_console(context, step)
        save_page_source(context, step)
