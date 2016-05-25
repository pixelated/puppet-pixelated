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

@staging
Feature: send_mail

  @mail_to_myself
  Scenario: user logs in end sends a mail to self
    Given I login as behave-testuser
    When I send a mail to myself
#    And I see that the mail was sent
    When I open the email
    Then I see a encrypted flag

  @unencrypted
  Scenario: user receives an unencrypted email
    Given I send an unencrypted email
    And I login as behave-testuser
    When I open the unencrypted email
    Then I see a unencrypted email flag

  @wip
  @undecryptable
  Scenario: user receives an email we cannot decrypt
    Given I send an email encrypted to someone else
    And I login as behave-testuser
    When I open the undecryptable email
    Then I see a undecryptable flag

  @logout
  Scenario: behave-testuser logs out
    Given I login as behave-testuser
    When I logout
    And I visit the user-agent
    Then I should see a login button
