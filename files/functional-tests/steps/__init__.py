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
import couchdb
import shutil
LEAP_HOME_FOLDER = os.environ.get('LEAP_HOME_FOLDER', '/var/lib/pixelated/.leap/')


def detect_hostname():
    return os.environ.get('TESTHOST') or  subprocess.check_output(['hostname', '-d']).strip()

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


def leap_login_url():
    return url_home() + '/login'


def _netrc_couch_credentials():
    with open('/etc/couchdb/couchdb.netrc', 'r') as netrc:
        netrc_line = netrc.readline().strip().split(' ')
    credentials = {}
    for index in xrange(0, len(netrc_line), 2):
        credentials[netrc_line[index]] = netrc_line[index+1]
    return credentials


def _delete_identity(server, username):
    email = '%s@%s' % (username, detect_hostname())
    filter_by_user_id = '''function(doc) { if (doc['address']=='%s') { emit(doc, null);}  }''' % email
    identities = server['identities']
    user_identities = identities.query(filter_by_user_id)
    for ident in user_identities:
        doc = identities.get(ident['id'])
        identities.delete(doc)


def _delete_data(server, user_id):
    user_db = 'user-%s' % user_id
    if user_db in server:
        del server[user_db]


def delete_soledad_server_db(user_id, username):
    couch_credentials = _netrc_couch_credentials()
    server = couchdb.Server("http://%(login)s:%(password)s@%(machine)s:5984" % couch_credentials)
    _delete_identity(server, username)
    _delete_data(server, user_id)    


def delete_soledad_client_db(user_id):
    soledad_folder = LEAP_HOME_FOLDER + user_id
    if os.path.exists(soledad_folder):
        shutil.rmtree(soledad_folder)
