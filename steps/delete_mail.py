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

from behave import then
from ..page_objects import PixelatedPage


@then('I delete the email')
def impl(context):
    pixelated_page = PixelatedPage(context)
    pixelated_page.delete_mail(
        context.pixelated_email,
        pixelated_page.random_subject(),
        240
    )


@then('I see it in the trash box')
def impl(context):
    pixelated_page = PixelatedPage(context)
    pixelated_page.go_to_trash()
    pixelated_page.is_mail_on_list(context.pixelated_email, pixelated_page.random_subject())


@then('I delete it permanently')
def impl(context):
    pixelated_page = PixelatedPage(context)
    pixelated_page.go_to_trash()
    pixelated_page.delete_mail(context.pixelated_email, pixelated_page.random_subject())
