{{/* vim: set filetype=mustache: */}}
{{/*
.Values.nameOverride typically looks like 'integration' or 'qa'. It gets passed
into helm as a set parameter from CI_ENVIRONMENT_SLUG which gets the value from
the deploy target being executed at environment.name. See .gitlab-ci.yml for
things marked as stage: deploy

.Release.name comes from the value given to the helm upgrade command. It typically
looks something like project-qa (ie, $PROJECT_NAME-$PROJECT_ENV).

See .gitlab-ci.yml for the helm command in bin/deploy.sh for how this is being
constructed
*/}}
{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
Removed the nameOverride here since Release.Name already contains environment.
*/}}
{{- define "chart.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Render the mariadb container hostname.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "chart.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Render the memcached container hostname.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "chart.memcached.fullname" -}}
{{- printf "%s-%s" .Release.Name "memcached" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a URL base for all project services
*/}}
{{- define "chart.project.url.base" -}}
{{- printf "%s.%s.kube.p2devcloud.com" .Values.ingress.url.env .Values.ingress.url.project -}}
{{- end -}}
