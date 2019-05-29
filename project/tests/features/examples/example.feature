Feature: Provide an example for new sites to build on
  In order to provide a starting example of a Behat feature
  As a developer
  I want to demonstrate basic Behat functionality

  # The `@api` tag tells the Drupal Extension that it needs to bootstrap Drupal.
  # In this case, it creates a user, which is then cleaned up automatically after the test.
  @api
  Scenario: Ensure as a logged in user, I can log out.
    Given I am logged in as a user with the "authenticated user" role
    When I click "Log out"
    Then I should be on the homepage
    And I am logged out of the site
