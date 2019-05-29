#!/usr/bin/env bash
## Initializes Particle
##
## This script runs within the Build container, so all tools are available.

if [ -e ~/.profile ]; then
  # Init the tools like npm within the cli container.
  # Needed if run via Docksal.
  source ~/.profile
fi

# Only download particle theme if it doesn't already exist.
FILE_COUNT=0
if [ -d ${THEME_PATH} ]; then
  # Can't just check for ${THEME_PATH} since node_modules might be cached.
  # So count the number of files in the theme to see if there are more than
  # just cached node_modules and package-lock.json.
  # Exclude . and .. when counting (using -A flag)
  FILE_COUNT=`ls -A1 ${THEME_PATH} | wc -l | tr -d ' '`
fi
if [ $FILE_COUNT -le 2 ]; then
  printf "$INFO_SLUG Downloading and installing Particle...\n"
  # Clear the directory for npx to install.
  rm -rf ${THEME_PATH}
  # Install latest Particle theme
  npx phase2/create-particle ${THEME_PATH}
  # @TODO: Remove this once Particle removes Husky.
  # Need to remove the default git hooks added by Husky from Particle.
  # They interfere with project hooks and with Drupal config import/export.
  rm -rf .git/hooks
fi

# @TODO: Run Particle theme generator.
