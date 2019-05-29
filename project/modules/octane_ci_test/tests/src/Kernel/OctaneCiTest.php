<?php

namespace Drupal\Tests\octane_ci_test\Kernel;

use Drupal\KernelTests\KernelTestBase;
use Drupal\Tests\user\Traits\UserCreationTrait;

/**
 * This is a test to ensure CI testing functionality.
 *
 * @group octane_ci_test
 */
class OctaneCiTest extends KernelTestBase {

  use UserCreationTrait;

  /**
   * {@inheritdoc}
   */
  public static $modules = ['system', 'user'];

  /**
   * {@inheritdoc}
   */
  protected function setUp() {
    parent::setUp();

    $this->setUpCurrentUser();
    $this->installEntitySchema('user');
  }

  /**
   * A simple kernel test.
   */
  public function testCi() {
    $user = $this->createUser();
    $this->assertFalse($user->hasPermission('administer users'));
  }

}
