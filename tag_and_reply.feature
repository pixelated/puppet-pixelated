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

@user_agent
Feature: Tag and reply
  As a user of Pixelated
  I want to tag my emails
  So that I can easily find them

  Scenario: User tags a mail, replies to it then checks that mail is in the right tag
    Given I have a mail in my inbox
    When I open the first mail in the 'inbox'
    When I add the tag 'website' to that mail
    Then I see that mail under the 'website' tag
    When I open the mail I previously tagged
    And I reply to it
    When I select the tag 'sent'
    Then I see the mail I sent

    
