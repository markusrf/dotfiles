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

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if
              vim.list_contains(
                treesitter.get_installed(),
                vim.treesitter.language.get_lang(args.match)
              )
          then
            vim.treesitter.start(args.buf)
            -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            -- vim.wo.foldmethod = "expr"
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

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = false,
        },
      }

      vim.keymap.set({ "n", "x", "o" }, "]]", function()
        require("nvim-treesitter-textobjects.move").goto_next_start(
          "@function.outer",
          "textobjects"
        )
        vim.cmd("normal! zz")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[[", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(
          "@function.outer",
          "textobjects"
        )
        vim.cmd("normal! zz")
      end)
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
      end)
    end,
  },
}
