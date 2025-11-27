#!/usr/bin/env bash
set -euo pipefail

# install brew
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW="$(brew --prefix 2>/dev/null || echo '/opt/homebrew')/bin/brew"

  $BREW analytics off

  if ! grep -q "$($BREW --prefix)/bin/bash" /etc/shells; then
    echo "Adding brew installed bash to /etc/shells"
    sudo sh -c "echo $($BREW --prefix)/bin/bash >> /etc/shells"
  fi

  $BREW bundle install --no-upgrade
fi


# install oh-my-zsh
if [[ -z "$ZSH" ]]; then
  echo "Installing oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  mkdir -p ~/.oh-my-zsh/completions
fi
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}


# install zsh plugins
if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  echo "Installing p10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  echo "Installing zsh-autosuggestions"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  echo "Installing zsh-syntax-highlighting"
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]]; then
  echo "Installing zsh-vi-mode"
  git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode.git $ZSH_CUSTOM/plugins/zsh-vi-mode
fi
if [[ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ]]; then
  echo "Installing fzf-tab"
  git clone --depth=1 https://github.com/Aloxaf/fzf-tab.git $ZSH_CUSTOM/plugins/fzf-tab
fi


# stow packages
echo "Restowing packages"
rm -f **/.DS_Store
rm -f ~/.config/**/.DS_Store
(cd packages; stow -t ~ -R *)


if ! gh extension list | grep -q "dlvhdr/gh-dash"; then
  echo "Installing gh extension gh-dash"
  gh extension install dlvhdr/gh-dash
fi


# to make bat know about extra themes
echo "Rebuilding bat cache"
bat cache --build
