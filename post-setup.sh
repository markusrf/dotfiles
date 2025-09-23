#!/usr/bin/env bash
set -euo pipefail

brew analytics off

brew update

sudo sh -c "echo $(brew --prefix)/bin/bash >> /etc/shells"

gh extension install dlvhdr/gh-dash

# to make bat know about extra themes
bat cache --build

