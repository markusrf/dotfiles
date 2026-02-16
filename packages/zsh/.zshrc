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

# Must be sourced before loading the zsh-syntax-highlighting plugin
# Files coming from https://github.com/catppuccin/zsh-syntax-highlighting
source ~/.zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh

function zvm_config() {
  ZVM_VI_HIGHLIGHT_FOREGROUND=black
  ZVM_VI_HIGHLIGHT_BACKGROUND=magenta
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-autosuggestions zsh-syntax-highlighting colored-man-pages zsh-vi-mode fzf-tab)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

setopt globdots
setopt ignoreeof

### NO NEED WITH ZSH-VI-MODE
# Key binds
# To find the code: press ctrl+v, then the key - it will print the control key code
# List of zsh commands can be found here: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Modifying-Text
# bindkey "\e[1;3D" backward-word      # ⌥←
# bindkey "\e[1;3C" forward-word       # ⌥→
# bindkey "^[[1;9D" beginning-of-line  # cmd+←
# bindkey "^[[1;9C" end-of-line        # cmd+→
# User ctrl+U for 'backward-kill-line'

DISABLE_AUTO_TITLE="true"
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim
export DOTFILES=$HOME/code/dotfiles

export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin/:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

ZVM_SYSTEM_CLIPBOARD_ENABLED=true
bindkey -v " " magic-space

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

eval "$(zoxide init zsh --cmd cd)"


# Need to set JAVA_HOME on mac when installed with asdf
if command -v asdf >/dev/null 2>&1; then
  asdf which java >/dev/null 2>&1 && . ~/.asdf/plugins/java/set-java-home.zsh
fi

if [[ -e ~/.work_funcs ]]; then
  source ~/.work_funcs
fi


###########
# ALIASES #
###########

alias -g NE='2>/dev/null'
alias -g DN='>/dev/null'
alias -g NUL='>/dev/null 2>&1'

# alias ls='colorls --sd'
alias ll='ls -lAhG'
alias mkdir='mkdir -p'
alias path='echo $PATH | tr -s ":" "\n"'

alias bb-check='cat Brewfile <(echo) Brewfile-extra <(echo) | brew bundle check --no-upgrade -v --file=-'
alias bb-install='cat Brewfile <(echo) Brewfile-extra <(echo) | brew bundle install --no-upgrade --file=-'
alias bb-upgrade='cat Brewfile <(echo) Brewfile-extra <(echo) | brew bundle upgrade --file=-'
alias bb-cleanup='cat Brewfile <(echo) Brewfile-extra <(echo) | brew bundle cleanup --file=-'

alias tf='terraform'
alias lg='lazygit'
alias lzd='lazydocker'
alias icat='kitten icat'

alias dcu='docker compose up --remove-orphans -d'
alias dcub='docker compose up --build --remove-orphans -d'
alias dcd='docker compose down'

alias gti="git"
alias gitsha="git log --oneline --color=always --pretty=format:'%C(cyan)%h%Creset %Cgreen%ch%Creset - %s %C(red)<%an>%Creset' | gum filter | cut -w -f1"
alias gitshac="gitsha | pbcopy"
alias gitrmb="git branch | cut -c 3- | gum choose --no-limit | xargs git branch -D"
alias gcatc="gitsha | xargs git cat-file commit"
alias gcl="git diff --shortstat `git hash-object -t tree /dev/null`"

alias nivm="nvim"

alias printcolors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'"'"'\n'"'"'}; done'
alias wttr='curl "wttr.in/Trondheim?M&format=%l:+%c+%t+(%f)+%w+Rain:%p+UV:%u+++Sunrise:%S+Sunset:%s\n"'
alias fzfchafa='fd --type f "\.(png|jpg|jpeg|gif|svg)" | fzf --preview="chafa {} --format symbols --symbols vhalf --stretch --size 60x16"'


#############
# FUNCTIONS #
#############

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

# Mac setup for pomo
function work() {
  timer ${1:-50}m --format 24h && terminal-notifier \
    -message Pomodoro \
    -title 'Work Timer is up! Take a Break ☕️🤩' \
    -sound Crystal
}

function rest() {
  timer ${1:-10}m --format 24h && terminal-notifier \
    -message Pomodoro \
    -title 'Break is over! Get back to work 🐸' \
    -sound Crystal
}

function pom() {
  SPLIT=$(gum choose "25/5" "50/10" "all done" --header "Choose a pomodoro split.")

  case "$SPLIT" in
    "25/5")
      WORK=25
      BREAK=5
      ;;
    "50/10")
      WORK=50
      BREAK=10
      ;;
    "all done" | *)
      return
      ;;
  esac

  work $WORK
  gum confirm "Ready for a break?" && rest $BREAK || pom
}

function gremote() {
  git config --get remote.origin.url | sed -E 's/(ssh:\/\/)?git@/https:\/\//' | sed 's/com:/com\//' | sed 's/\.git$//' | head -n1
}

function ogremote() {
  open -u $(gremote)
}

function pyd2jq() {
  echo "$1" | sed 's/'\''/"/g' | sed 's/None/null/g' | jq
}

function mvi() {
  FILES=$(fd -t f -H | fzf -m)
  [[ -z "$FILES" ]] && return
  FILES="${FILES//$'\n'/ }"
  TARGET=$(fd -t d -H | fzf)
  [[ -z "$TARGET" ]] && return
  mv $(echo $FILES) "$TARGET"
}
