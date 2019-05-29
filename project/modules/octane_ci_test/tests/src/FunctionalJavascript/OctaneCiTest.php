<?php

namespace Drupal\Tests\octane_ci_test\FunctionalJavascript;

use Drupal\FunctionalJavascriptTests\WebDriverTestBase;

/**
 * Test to ensure JS capabilities exist in the CI environment.
 *
 * @todo Setup headless chrome container.
 *
 * @group octane_ci_test
 */
class OctaneCiTest extends WebDriverTestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = ['node'];

  /**
   * Test to ensure browser capabilities of CI.
   */
  public function testCi() {
    $user = $this->createUser([], NULL, TRUE);
    $this->drupalLogin($user);

    $this->createContentType(['type' => 'page']);
    $node = $this->createNode(['type' => 'page']);

    $this->drupalGet($node->toUrl()->toString());
    $this->assertSession()->statusCodeEquals(200);
    $this->assertSession()->linkExists('Delete');
    $this->clickLink('Delete');

    $this->drupalGet($node->toUrl()->toString());
    $this->assertSession()->statusCodeEquals(404);
  }

}
