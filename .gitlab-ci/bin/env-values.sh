#!/usr/bin/env bash
# Sets chart values from environment variables.
# Projects shouldn't need to modify this unless you add new environment
# variables that you need to reference in your chart templates.

# Read environment variables from .env file, skipping comments.
export $(grep -v '^#' .env | xargs)

# Output the environment variables into YAML format.
echo "env:
  projectName: ${PROJECT_NAME}
  profile: ${PROFILE}
  docroot: /var/www/${DOCROOT}
  projectDir: ${PROJECT_DIR}
  configPath: ${CONFIG_PATH}
  themePath: ${THEME_PATH}
volumeMounts:
  cmsfiles:
    mountPath: /var/www/${DOCROOT}/sites/default/files
mariadb:
  mariadbUser: ${MYSQL_USER}
  mariadbPassword: ${MYSQL_PASSWORD}
  mariadbDatabase: ${MYSQL_DATABASE}
"
