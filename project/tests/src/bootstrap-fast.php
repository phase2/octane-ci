<?php

/**
 * @file
 * A bootstrap file for `phpunit` test runner.
 *
 * This is a copy of the file that ships with Drupal Test Traits and has been
 * customized.
 *
 * This file is for declaring namespace file mapping for autoloading that
 * happens before PHPUnit's `setUp` method is run. This includes any traits,
 * base classes being extended, and class constants used to set class
 * properties.
 *
 * For instance, this would require the class be found by this bootstrap file:
 *
 * @code
 *
 *   use \Drupal\Tests\search_api\Kernel\SearchApiTestBase;
 *   use \Drupal\group\Entity\GroupInterface;
 *   use \Drupal\message\MessageInterface;
 *
 *   class FooBarTest extends SearchApiTestBase {
 *
 *     protected $foo = GroupInterface::SOME_CONSTANT;
 *
 *     public function testSomething() {
 *       $this->assertTrue(MessageInterface::ANOTHER_CONSTANT);
 *     }
 *   }
 *
 * @endcode
 *
 * In this example, search_api and the group module would need to be autoloaded,
 * but the message module (which has a class used from withing a test method)
 * would not need to be specified here since it will be found by Drupal's
 * normal autoloading.
 *
 * If you get 'class not found' 'during test running, you may add copy and add
 * the missing namespaces to bottom of this file. Then specify that file for
 * PHPUnit bootstrap.
 *
 * Alternatively, use the bootstrap.php file in the drupal-test-traits library
 * which registers all the namespaces that Drupal tests could ever possibly
 * encounter. This is much slower, especially when running inside a container
 * on Docker for Mac.
 */

use weitzman\DrupalTestTraits\AddPsr4;

list($finder, $class_loader) = AddPsr4::add();
$root = $finder->getDrupalRoot();

// Needed for kernel tests.
$GLOBALS['namespaces'] = [];

// Register more namespaces, as needed. These are only necessary for code
// referenced in the test files (such as class constants, traits, etc). Once
// the test is running, autoloading works as normal once Drupal is bootstrapped.
$class_loader->addPsr4('Drupal\Tests\block\\', "$root/core/modules/block/tests/src");
