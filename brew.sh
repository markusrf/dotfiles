#!/usr/bin/env bash
set -euo pipefail

brew analytics off

brew update
brew upgrade

brew install asdf
brew install bat
brew install coreutils
brew install curl
brew install fd
brew install ffmpeg
brew install fzf
brew install git
brew install git-delta
brew install gnupg
brew install gum
brew install jq
brew install nano
brew install nanorc
brew install pinentry-mac
brew install pre-commit
brew install stow
brew install terminal-notifier
brew install caarlos0/tap/timer
brew install trufflesecurity/trufflehog/trufflehog
brew install ttyd
brew install vhs

brew install --cask firefox@developer-edition
brew install --cask font-fira-code-nerd-font  # https://github.com/tonsky/FiraCode
brew install --cask keymapp
brew install --cask kitty
brew install --cask obsidian
brew install --cask rectangle
brew install --cask spotify
brew install --cask visual-studio-code

brew install bash
sudo sh -c "echo $(brew --prefix)/bin/bash >> /etc/shells"
