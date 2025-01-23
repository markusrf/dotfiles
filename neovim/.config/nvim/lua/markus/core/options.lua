vim.cmd("let g:netrw_liststyle = 3")
vim.cmd.colorscheme "catppuccin-macchiato"
-- vim.cmd.colorscheme "rose-pine-moon"
-- vim.cmd.colorscheme "rose-pine-main"
-- vim.cmd.colorscheme "flexoki-dark"

local opt = vim.opt
opt.relativenumber = true

opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2    -- 2 spaces for indent width
opt.expandtab = true  -- expand tab to spaces
opt.autoindent = true -- copy indent of current line to new line

-- :h autoindent for help

opt.wrap = false

-- search settings
opt.ignorecase = true -- case insensitive search
opt.smartcase = true -- uses mixed case for case sensitive search

-- opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work

-- opt.termguicolors = true
opt.background = "dark" -- colorschemes can be light or dark
opt.signcolumn = "yes" -- show sign column so that text doesnt shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position 

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

