#!/usr/bin/env bash
# Common script to build the code base and push a docker image to registry.
# Called from .gitlab-ci.yml in the "build" stage

set -ex

# Login so we can push images to the registry
docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY

# Initial setup if this is Octane.
if [[ -e .octane/setup.sh && $1 != "-skip" ]]; then docker-compose -f .gitlab-ci/build.yml run --rm base .octane/setup.sh; fi

# assemble the codebase
docker-compose -f .gitlab-ci/build.yml run --rm base ./bin/make -y

# bundle it into a docker image
cp .gitlab-ci/Dockerfile Dockerfile

# Use previous build as cache for performance.
docker build --cache-from ${WEB_IMAGE}:${CI_COMMIT_REF_SLUG} -t ${WEB_IMAGE}:${CI_COMMIT_SHA} .

# Tag it based on slug (branch name) too which can allow for easier commands
# of the form "deploy the latest version of BRANCH"
docker tag ${WEB_IMAGE}:${CI_COMMIT_SHA} ${WEB_IMAGE}:${CI_COMMIT_REF_SLUG}

# Push all the plain tags and the qa variants and for cache
docker push ${WEB_IMAGE}:${CI_COMMIT_SHA}
docker push ${WEB_IMAGE}:${CI_COMMIT_REF_SLUG}
