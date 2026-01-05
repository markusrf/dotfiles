local parsers = {
  "vimdoc",
  "javascript",
  "typescript",
  "lua",
  "bash",
  "python",
  "terraform",
  "markdown",
  "markdown_inline",
  "json",
  "yaml",
  "dockerfile",
  "gitignore",
  "git_config",
  "sql",
  "toml",
  "vhs",
  "zsh",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})
      treesitter.install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          if
              vim.list_contains(
                treesitter.get_installed(),
                vim.treesitter.language.get_lang(args.match)
              )
          then
            vim.treesitter.start(args.buf)
            -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            -- vim.wo.foldmethod = 'expr'
            -- indentation, provided by nvim-treesitter
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      local old_options_no_longer_supported = {
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-n>",
            node_incremental = "<C-n>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-m>",
          },
        },
      }
    end
  },

        },
}
