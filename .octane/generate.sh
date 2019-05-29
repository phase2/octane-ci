#!/usr/bin/env bash
## First time project generation.
## Used for interactive project creation.
##
## Only called by Docksal.
## Runs in the cli container so all tools are available.

# Re-declared here since this is run outside the container.
INFO_SLUG="\033[33m[INFO]\033[0m"

set -e

printf "${INFO_SLUG} Removing Octane-specific lock file...\n"
rm -rf composer.lock

printf "${INFO_SLUG} Generating new project...\n"
# @TODO: Prompt for project name, etc to setup the .env file.

printf "${INFO_SLUG} Setup new project...\n"
.octane/setup.sh

# @TODO: Prompt for theme name and generate theme.
