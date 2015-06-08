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


# XXX: must implement with HTML content
@user_agent
Feature: search mail and deletion
  As a user of pixelated
  I want to search for emails
  So I can manage them

  Scenario: User searches for a mail and deletes it
    Given I have a mail in my inbox
    When I search for a mail with the words "the body of this message"
    When I open the first mail in the mail list
    Then I see one or more mails in the search results
    When I try to delete the first mail
    When I select the tag 'trash'
    Then the deleted mail is there
