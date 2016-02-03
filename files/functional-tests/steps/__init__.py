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
import ConfigParser
import os

config = ConfigParser.ConfigParser()
current_dir = os.path.dirname(os.path.abspath(__file__))
config_path = os.path.join(current_dir, '..', 'config.cfg')
config.read(config_path)
dispatcher_address = config.get('staging', 'dispatcher_address')


def url_home(port=None):
    # if port is not None:
    #     return 'https://localhost:%d' % port
    # else:
    #     return 'https://localhost'
    if port is not None:
        return '%s:%d' % (dispatcher_address, port)
    else:
        return dispatcher_address


def login_url():
    return url_home(port=8080) + '/auth/login'


def logout_url():
    return url_home(port=8080) + '/auth/logout'


def signup_url():
    return url_home() + '/signup'


def behave_email():
    return config.get('staging', 'behave_email')


def behave_password():
    return config.get('staging', 'behave_password')

def behave_testuser():
    return config.get('staging', 'behave_testuser')

