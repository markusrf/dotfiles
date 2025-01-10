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

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

source ~/code/div/zsh-syntax-highlighting/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

alias tf='terraform'

alias lg='lazygit'

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

function cdi() {
  p="$(fd -t d -H | fzf)"
  if [ -n "$p" ]; then
    cd "$p"
  fi
}

function mvi() {
  FILES=$(fd -t f -H | fzf -m)
  [[ -z "$FILES" ]] && return
  FILES="${FILES//$'\n'/ }"
  TARGET=$(fd -t d -H | fzf)
  [[ -z "$TARGET" ]] && return
  mv $(echo $FILES) "$TARGET"
}
