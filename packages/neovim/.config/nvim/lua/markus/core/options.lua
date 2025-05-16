vim.cmd("let g:netrw_liststyle = 3")
vim.cmd.colorscheme "catppuccin-macchiato"
-- vim.cmd.colorscheme "rose-pine-moon"
-- vim.cmd.colorscheme "rose-pine-main"
-- vim.cmd.colorscheme "flexoki-dark"

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.termguicolors = true -- Enable true color support
opt.scrolloff = 3

opt.tabstop = 2        -- Number of spaces per tab
opt.shiftwidth = 2     -- Indentation width
opt.expandtab = true   -- Convert tabs to spaces
opt.autoindent = true  -- Copy indent of current line to new line
opt.smartindent = true -- Auto-indent new lines
opt.inccommand = "split"

-- search settings
opt.ignorecase = true               -- case insensitive search
opt.smartcase = true                -- uses mixed case for case sensitive search

opt.wrap = false                    -- textwrap
opt.cursorline = true               -- highline the entire line the cursor is on
opt.background = "dark"             -- colorschemes can be light or dark
opt.signcolumn = "yes"              -- show sign column so that text doesnt shift
opt.backspace = "indent,eol,start"  -- allow backspace on indent, end of line or insert mode start position
opt.clipboard:append("unnamedplus") -- use system clipboard as default register
opt.undofile = true                 -- save undohistory to file
