# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

source ~/code/div/zsh-syntax-highlighting/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

setopt globdots
setopt ignoreeof

# Key binds
# To find the code: press ctrl+v, then the key - it will print the control key code
# List of zsh commands can be found here: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Modifying-Text
bindkey "\e[1;3D" backward-word      # ⌥←
bindkey "\e[1;3C" forward-word       # ⌥→
bindkey "^[[1;9D" beginning-of-line  # cmd+←
bindkey "^[[1;9C" end-of-line        # cmd+→
# User ctrl+U for 'backward-kill-line'

DISABLE_AUTO_TITLE="true"
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim
export DOTFILES=$HOME/code/dotfiles

# poetry
export PATH="/Users/markus.foss/.local/bin:$PATH"

# alias ls='colorls --sd'
alias ll='ls -lAhG'
alias mkdir='mkdir -p'
alias path='echo $PATH | tr -s ":" "\n"'

# python
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin/:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

# disable mouse acceleration
defaults write .GlobalPreferences com.apple.mouse.scaling -1

export PATH="/opt/homebrew/opt/node@18/bin:$PATH"

. $(brew --prefix)/opt/asdf/libexec/asdf.sh

# fzf
source <(fzf --zsh)
# fzf catppuccin
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--multi"

# fzf-git
source ~/.zsh_scripts/fzf-git.sh

if [[ -e ~/.work_funcs ]]; then
  source ~/.work_funcs
fi

eval "$(zoxide init zsh --cmd cd)"

# function to open obsidian
# arguments:
#   $1 - vault name
#   $2 - file name
function obsidian() {
    COMMAND="open \"obsidian://open"
    [ -z "$1" ] && VAULT="" || VAULT="?vault=$1"
    [ -z "$2" ] && FILE="" || FILE="&file=$2"
    COMMAND="$COMMAND$VAULT$FILE\""
    echo "$COMMAND"
    eval "$COMMAND"
}

# open obsidian vault in VS Code
function obsidian-code() {
    code ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/vault
}

alias bb-check='cd $DOTFILES; cat Brewfile <(echo) Brewfile-extra <(echo) | brew bundle check --file=-'
alias bb-install='cd $DOTFILES; cat Brewfile <(echo) Brewfile-extra <(echo) | brew bundle install --file=-'
alias bb-cleanup='cd $DOTFILES; cat Brewfile <(echo) Brewfile-extra <(echo) | brew bundle cleanup --file=-'

alias tf='terraform'

alias lg='lazygit'
alias lzd='lazydocker'

alias dcu='docker compose up -d'
alias dcub='docker compose up -d --build'
alias dcd='docker compose down'

alias gitsha="git log --oneline --color=always --pretty=format:'%C(cyan)%h%Creset %Cgreen%ch%Creset - %s %C(red)<%an>%Creset' | gum filter | cut -w -f1"
alias gitshac="gitsha | pbcopy"
alias gitrmb="git branch | cut -c 3- | gum choose --no-limit | xargs git branch -D"
alias gcatc="gitsha | xargs git cat-file commit"

function gitstage() {
    ADD="Add"
    RESET="Restore"

    ACTION=$(gum choose "$ADD" "$RESET")
    echo "$ACTION"

    if [[ "$ACTION" == "$ADD" ]]; then
        git status --short | gum choose --no-limit | cut -c 4- | cut -w -f1 | xargs git add
    else
        git status --short | gum choose --no-limit | cut -c 4- | cut -w -f1 | xargs git restore --staged
    fi

    git status --short
}

# . "$HOME/.cargo/env"

# Mac setup for pomo
function work() {
    timer ${1:-50}m --format 24h && terminal-notifier \
        -message 'Take a break ☕️🤩' \
        -title 'Work timer is up!' \
        -sound Crystal
}

function rest() {
    timer ${1:-10}m --format 24h && terminal-notifier \
        -message 'Get back to work 🐸' \
        -title 'Break is over!' \
        -sound Crystal
}

function gremote() {
  git config --get remote.origin.url | sed -E 's/(ssh:\/\/)?git@/https:\/\//' | sed 's/com:/com\//' | sed 's/\.git$//' | head -n1
}

function ogremote() {
  open -u $(gremote)
}

alias opr='open -u "$(gremote)/compare/$(git rev-parse --abbrev-ref HEAD)?expand=1"'

function mvi() {
  FILES=$(fd -t f -H | fzf -m)
  [[ -z "$FILES" ]] && return
  FILES="${FILES//$'\n'/ }"
  TARGET=$(fd -t d -H | fzf)
  [[ -z "$TARGET" ]] && return
  mv $(echo $FILES) "$TARGET"
}

alias printcolors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'"'"'\n'"'"'}; done'

