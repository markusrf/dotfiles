
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ $(uname -m) == "x86_64" ]]; then
    eval "$(/usr/locl/bin/brew shellenv)"
fi
