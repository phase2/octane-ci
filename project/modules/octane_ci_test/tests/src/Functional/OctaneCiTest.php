<?php

namespace Drupal\Tests\octane_ci_test\Functional;

use Drupal\Tests\BrowserTestBase;

/**
 * This is a test to ensure CI testing functionality.
 *
 * @group octane_ci_test
 */
class OctaneCiTest extends BrowserTestBase {

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
    $node = $this->createNode([
      'type' => 'page',
      'title' => $this->randomGenerator->word(32),
    ]);

    $this->drupalGet($node->toUrl()->toString());
    $this->assertSession()->statusCodeEquals(200);
    $this->assertSession()->responseContains($node->getTitle());
  }

}
