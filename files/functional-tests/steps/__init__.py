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
import os
import subprocess

def detect_hostname():
    if os.environ.get('TESTHOST') is not None:
        return os.environ.get('TESTHOST')
    else:
        return subprocess.check_output(['hostname', '-d']).strip()

hostname = detect_hostname()

user_agent_address = 'https://%s' % hostname


def url_home(port=None):
    if port is not None:
        return '%s:%d' % (user_agent_address, port)
    else:
        return user_agent_address


def login_url():
    return url_home(port=8083) + '/login'


def logout_url():
    return url_home(port=8083) + '/logout'


def signup_url():
    return url_home() + '/signup'


def behave_email():
    return '%s@%s' % (behave_testuser(), hostname)


def behave_password():
    return 'Eido6aeg3za9ooNiekiemahm'


def behave_testuser():
    return 'behave-testuser'

