<?php
/**
 * Common site settings.
 *
 * The process of running 'grunt install' will automatically set up a Drupal
 * sites/default/settings.php which includes this file.
 */

// Forcibly disable poorman's cron.
$conf['cron_safe_threshold'] = 0;

// Location of config for import/export.
$config_directories = array(
  CONFIG_SYNC_DIRECTORY => '/var/www/project/config/default'
);

// Use environment variables for database credentials.
// These are passed into the docker web and db containers.
$databases['default']['default'] = array (
  'database' => getenv('MYSQL_DATABASE'),
  'username' => getenv('MYSQL_USER'),
  'password' => getenv('MYSQL_PASSWORD'),
  'host' => getenv('MYSQL_HOST'),
  'port' => getenv('MYSQL_PORT'),
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
  'prefix' => '',
);

// Load environment specific settings.
// Using docker environment by default, but can change this depending upon
// available hosting environment variables.
if ($drupal_env = getenv('PROJECT_ENV')) {
  if ($drupal_env === 'local') {
    // Local development.
    include __DIR__ . '/settings.common-local.php';
  }
  else {
    // Default to Client environments.
    require __DIR__ . '/settings.common-client.php';
  }
}
else {
  // Client environments.
  require __DIR__ . '/settings.common-client.php';
}
