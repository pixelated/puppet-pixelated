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

Feature: account

  @register
  Scenario: user goes to signup-page
    When I visit the signup-page
    Then I should see a signup button

  @register
  Scenario: user goes to signup-page and registers new account
    When I visit the signup-page
    And  I register
    Then I see the control-panel

  @login 
  Scenario: user goes to dispatcher
    When I visit the dispatcher
    Then I should see a login button

  @login
  Scenario: user goes to dispatcher and enters credentials
    When I visit the dispatcher
    And  I login
    Then I see the inbox
