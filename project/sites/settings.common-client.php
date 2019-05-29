<?php
/**
 * Client's environment site settings.
 */

// Active config-split.
// $config['config_split.config_split.prod']['status'] = TRUE;

// CLIENT-SPECIFIC settings go here.

/**
 * Load local development override configuration, if available.
 *
 * Use settings.local.php to override variables on secondary (staging,
 * development, etc) installations of this site. Typically used to disable
 * caching, JavaScript/CSS compression, re-routing of outgoing emails, and
 * other things that should not happen on development and testing sites.
 *
 * NOTE: Do not add settings.local.php to your git repo as it is only for
 * local changes specific to individual developers.
 *
 * Keep this code block at the end of this file to take full effect.
 */
if (file_exists(__DIR__ . '/default/settings.local.php')) {
  include __DIR__ . '/default/settings.local.php';
}
