<?php

/**
 * @file
 * Contains an example Behat context.
 */

use Drupal\DrupalExtension\Context\RawDrupalContext;

/**
 * Example Behat context for project-specific step definitions.
 *
 * Descrete functionality can be split up into separate contexts. They should
 * typically extend the RawDrupalContext if they involve Drupal code, but they
 * don't necessarily have to.
 */
class ExampleContext extends RawDrupalContext {

  /**
   * Demonstrates a custom step definition.
   *
   * @Then I am logged out of the site
   */
  public function assertLoggedOut() {
    $this->getMink()->getSession()->visit('/user/login');
    $this->getMink()->assertSession()->fieldExists('pass');
  }

}
