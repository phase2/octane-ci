#!/usr/bin/env bash
## First time project setup.
## Called from both GitLab CI and via Generate for new projects.

set -e

# Install Particle.
.octane/particle.sh

