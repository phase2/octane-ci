#!/usr/bin/env bash
# Common script to deploy a built image to a Kubernetes cluster.
# When calling this script, be sure to set the "environment:" values.
# Called from .gitlab-ci.yml in the "deploy" stage

set -ex

# Display versions of docker, etc. Comes from gitlab-ci-workspace container.
/versions.sh

# TODO: REMOVE DEBUG
ls -al

# Remove any previous manifests from cache.
rm -rf .gitlab-ci/manifests
mkdir .gitlab-ci/manifests

# Create a Docker Registry secret (if it doesn't exist) so we can pull images
# via imagePullSecrets. This depends on a deploy token having been created
# with name gitlab-deploy-token. See the note about the special naming at
# https://gitlab.com/help/user/project/deploy_tokens/index#read-container-registry-images
kubectl get secret gitlab-registry-secret || kubectl create secret docker-registry gitlab-registry-secret --docker-server=${CI_REGISTRY} --docker-username=${CI_DEPLOY_USER} --docker-password=${CI_DEPLOY_PASSWORD} --docker-email=${GITLAB_USER_EMAIL}

# Download chart dependencies.
helm dependency build .gitlab-ci/chart

# Create env configMap from .env file.
#   Remove the quotes around values since kubectl expects simple key=value
cat .env | tr -d "\"" >.gitlab-ci/.env
kubectl create configmap ${RELEASE_NAME}-env-config --from-env-file=.gitlab-ci/.env -o yaml --dry-run > .gitlab-ci/manifests/${RELEASE_NAME}-env-config.yaml

# Create additional values from environment.
.gitlab-ci/bin/env-values.sh > .gitlab-ci/env-values.yaml

# Generate the manifests from the chart templates.
helm template -f .gitlab-ci/env-values.yaml --output-dir .gitlab-ci/manifests --name ${RELEASE_NAME} --set nameOverride=${CI_ENVIRONMENT_SLUG} --set image.repository=${WEB_IMAGE} --set image.tag=${CI_COMMIT_SHA} --set env.tier=${PROJECT_ENV} --set build_id="build-${CI_JOB_ID}" --set ingress.url.env=${PROJECT_ENV} --set ingress.url.project=${PROJECT_NAME} --debug .gitlab-ci/chart

# Remove un-needed mariadb-test pod.
rm -f .gitlab-ci/manifests/chart/charts/mariadb/templates/test-runner.yaml
rm -f .gitlab-ci/manifests/chart/charts/mariadb/templates/tests.yaml

# Send helm manifests to kubectl to create/update the pods.
kubectl apply --recursive --filename .gitlab-ci/manifests

# Wait for pods to become available.
.gitlab-ci/bin/pods-ready.sh ${RELEASE_NAME}
