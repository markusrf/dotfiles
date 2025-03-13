# dotfiles

## Poetry
Does not support having config in `~/.config`, so have to run this after stowing pypoetry:
```sh
ln -s "$(realpath ~)/.config/pypoetry/config.toml" "$(realpath ~)/Library/Application Support/pypoetry/config.toml"
```

And this for each project:
```sh
ln -s "$(realpath ~)/.config/nvim/pyrightconfig-global.json" "project/path/pyrightconfig.json"
```

