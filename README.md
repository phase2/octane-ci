# NOTE
This repo is currently out of date and should not be used. Development of Octane-CI is being done within the private Phase2 GitLab repository.  This public repo will be updated in the future.

# Octane
This is a composer project used to spin up a starting instance of Drupal 8 Octane.
Octane is a Drupal 8 project scaffold that provides the following features:
* Uses the Acquia/Lightning distribution.
* Uses Particle for the Pattern-Lab based theme.
* Adds common modules needed by most large Drupal 8 sites.
* Provides starting configuration for Docksal.
* Provides starting configuration for CI on GitLab.

## Quick Setup Guide

1. Clone this repo and use your project's name as the directory name.
2. Update the `.env` file as needed for your project.
3. Run `fin init`.
4. For the Drupal site, open `http://PROJECTNAME.docksal`
5. For Pattern Lab, run `fin theme` and open `http://design.PROJECTNAME.docksal`

## Installation
To create a Drupal Octane project clone this repository to a directory
named for your project.

Scripts for managing your site are located in the ``bin`` folder:
* **Native** (no docker containers) - run scripts in ``./bin`` directly.
* **Docksal** - run a script via ``fin scriptname``.

To initialize your Drupal project, run the ``init`` script. 
It takes an optional argument to specify which "profile" to install.
By default the "Lightning" profile will be used. Other options are
"standard" or "minimal".

This will create the docker containers, create a database, and install Drupal.
Your site will be available at ``projectname.docksal`` for Docksal.

Docksal example:
```
fin init
```

If configuration files are detected in the ``src/config/default`` directory,
the site will be installed using this existing config and the profile argument
will be ignored.

## Other scripts
Custom scripts for your project should be created in the ``/bin`` folder and
then referenced from Docksal (it is symlinked to ``.docksal/commands``)

Octane comes with the following example scripts:

* `fin import` : Used when you start working in a new branch and want to import
the latest configuration.  Done after a `git pull`.  If this does not detect
a valid Drupal installation it will prompt you to install a profile.
* `fin export` : Used when you have finished work and want to export your
configuration before doing a commit/push.
* `fin make` : Run `composer install` to install/update dependencies. 
* `fin rebuild`: Calls both `fin make` followed by `fin import`. Used when
starting a new branch to ensure you have all proper dependencies installed.
* `fin validate` : Runs PHPCS style checks. Should be done before commit/push.
CI build will fail if validation doesn't pass.
* `fin test` : Runs tests.  Takes an argument for `unit`, `kernel`, `functional`,
`functional-javascript`, `existing-site`, `behat` to determine which phpUnit test-suite
to run. Without arguments it will run all except unit tests. If multiple 
arguments are passed, they are sent directly to phpUnit.
* `fin install` : Reinstall Drupal from scratch.
* `fin newticket`: Prompts for a JIRA ticket number and creates a new ``feature/*``
branch. Modify this script if your project is not using the default Wunderflow branch strategy.
* `fin fix-perms`: Sets the ownership and permission of the Drupal ``sites/default/files``
folder. Used by other scripts.
* `fin theme`: Used to compile the theme and then run browserstack to watch for sass, js, twig changes.

## Docker Containers
Docksal defines a default stack and
allows you to override the configuration in ``.docksal/docksal.yml`` which uses
docker-compose syntax but only needs to contain the local overrides.

Default environment variables for the project and containers are defined in the ``.env`` file
which Docksal symlinks to ``.docksal/docksal-local.env`` file.
Docksal specific variables are defined in ``.docksal/docksal.env``.

The following containers will be created and used for your site:

* ``web`` - The Apache web container.
* ``db`` - The MySQL (Docksal) or MariaDB (Outrigger) database container.
Default user is ``admin`` and pass ``admin`` can be changed in the environment
variables or db container configuration.

### Build/CLI Container
One of the main priciples of Octane is to minimize the number of tools installed
on your local computer (only Composer) and instead perform most tasks within a 
docker "build" container that contains all the tools.

In DockSal, the Build container is called ``cli`` and is defined within the
default services stack, much like ``web`` or ``db`` and can be overridden
using the ``docksal.yml`` file.  Docksal provides its own set of aliases for
common applications such as ``fin drush``, ``fin composer``, etc.  To
run a script within the build container, use the command syntax:
```$xslt
fin exec bin/SCRIPTNAME.sh
```

To open a bash shell into the Docksal Build/CLI container, use
```$xslt
fin bash
```

When creating a custom command for Docksal in the ``./bin``
directory, you can add the comment
```$xslt
#: exec_target = cli
```
to the top of your script command file to cause it to be executed within the
Build/CLI container instead of running locally.

## Git Branching
By default, Octane is set up to support the [Wunderflow](https://wunderflow.wunder.io/) 
workflow. Main branches should be named for the environment to be created
in the cloud via GitLab CI.  Branch names can be changed in the `.env` file.
By default, the following branch names are used:

* `master` : The mainline branch used by the QA analyst to perform full release
testing. An alternate name of `qa` is also supported.
**This is the branch used as the base for new `feature/*` branches.**
* `develop` : The mainline branch where developer feature branches are initially
merged for test and integration.   An alternate name of `test` is also supported.
**This is the DEFAULT branch of a project and is what merge-requests are created
against for initial integration testing.**
* `feature/*` : Individual branches for each JIRA ticket or feature. Created using
`master` branch as the base, and then merged into `develop` for integration.

## GitLab CI Integration
The `.gitlab-ci` folder contains all of the scripts, charts, templates, etc for the
integration with the GitLab CI service.

Project CI jobs are defined within the `.gitlab-ci.yml` configuration file.  By default,
the following job stages are defined:

* `tasks` : Contains manually executed tasks for one-off needs, such as reinstalling Drupal
in an environment, or cleaning up the Kubernetes cloud environment for a project.
* `build` : Responsible for building the code base (composer, npm, etc) and building a
docker image of the site pushed to the GitLab registry.  Runs the `bin/make` script.
* `validate` : Responsible for linting, checking code style, and running Unit tests.
Runs the `bin/validate` script.
* `deploy` : After validation, this stage pushes the docker image for the project to
the Kubernetes cluster using the charts and templates defined within the `.gitlab-ci` folder.
Projects should exercise caution when modifying these charts when adding additional needed
services.  If you have added additional containers to your `docksal.yml` configuration
you will likely need to make similar changes and additions to the charts needed to
create those containers within the Kubernetes cluster.
* `update` : Responsible for installing Drupal, or updating Drupal (clear cache, update,
config-import, etc). Runs the `bin/import` script.
* `test` : Responsible for running the full set of tests (except Kernel).  Octane
includes some sample `ExistingSite` tests to verify the Drupal environment is working.
Runs the `bin/test` script.
* `notify` : This stage can send notifications based on success or failure.
By default this is set to send notifications to flowdock if you have set the
FLOWDOCK_API_TOKEN environment variable in your GitLab project CI/CD settings.
* `cleanup` : This stage provides manual tasks for cleaning up and destroying
the deployment on the Kubernetes cluster.

The above pipeline is configured by default to trigger on any push/merge to either
the `develop` or `master` main branches. For each branch, a site will be deployed to
`www.BRANCH.PROJECT.kube.p2devcloud.com` within the Kubernetes Cluster.

Commits to any `feature/*` branch will run a condensed pipeline of only the
`build` and `validate` stages, but will not cause additional sites to be created.
A manual `deploy` task can be triggered for a feature branch that will build
the site and install from scratch and spin up an environment with the url of
`www.feature-HASH.PROJECT.kube.p2devcloud.com` within the Kubernetes Cluster.

The `notify` stage has separate jobs for notifications about the mainline branches
vs the feature branches.

If you wish the sites to have different URLs from the name of the branch, you
will need to copy the `deploy` scripts in the `.gitlab-ci.yml` job configuration and
create new jobs within the stages and set the `PROJECT_ENV` variable to the
desired environment name associated with the branch (one job per branch).
Each additional job running in that branch (update, test, etc) will also need
to be duplicated and given the specific environment name.
