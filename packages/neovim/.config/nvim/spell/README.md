# Spell dictionaries

Info on how the dictionaries were created. The patch to the Norwegian dictionary was done by Claude.

## English dictionary

Downloaded from the Vim runtime spell mirror:

```sh
curl -fsSL -o en.utf-8.spl "https://ftp.nluug.nl/vim/runtime/spell/en.utf-8.spl"
curl -fsSL -o en.utf-8.sug "https://ftp.nluug.nl/vim/runtime/spell/en.utf-8.sug"
```

## Norwegian dictionary

Source: LibreOffice Bokmål Hunspell dictionary, compiled to a Vim `.spl`
with `:mkspell`. Better than the Vim-mirror `nb` file.

Fetch source

```sh
curl -fsSL -o src/nb_NO.aff https://raw.githubusercontent.com/LibreOffice/dictionaries/master/no/nb_NO.aff
curl -fsSL -o src/nb_NO.dic https://raw.githubusercontent.com/LibreOffice/dictionaries/master/no/nb_NO.dic
```

Vim's `mkspell` only partially supports the triple-consonant compound rules, and
with them enabled it wrongly marks valid standalone words (e.g. `her`) as
forbidden, which `.add` cannot override. Disable them (keeps normal compounding):

```sh
LC_ALL=C sed -i '' -E \
  's/^(CHECKCOMPOUNDTRIPLE|SIMPLIFIEDTRIPLE)$/# \1 (disabled: vim mkspell over-forbids standalone words like "her")/' \
  src/nb_NO.aff
```

Compile the main dictionary

```sh
nvim --headless "+mkspell! $PWD/nb $PWD/src/nb_NO" +qa
rm -f nb.utf-8.sug
```
