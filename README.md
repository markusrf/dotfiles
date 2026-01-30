# dotfiles

To get started, run the install script:
```sh
# Installs homebrew, brewfile, oh-my-zsh, zsh plugins and stows all packages
./install.sh
```

To apply Mac settings:
```sh
./macos.sh
```

To stow individual package:
```sh
cd packages
stow -t ~ packagename
```
