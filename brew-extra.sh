#!/usr/bin/env bash
set -euo pipefail

brew update
brew upgrade

brew install azure-cli
brew install go
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew install postgresql
brew tap snyk/tap
brew install snyk
brew install terraform-docs
brew install tflint
brew install tfsec
