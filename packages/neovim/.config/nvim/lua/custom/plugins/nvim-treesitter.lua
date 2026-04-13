local parsers = {
  "bash",
  "dockerfile",
  "git_config",
  "gitignore",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "sql",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vhs",
  "vimdoc",
  "yaml",
  "zsh",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- TODO: repo is archived, latest version requires nvim 0.12
    -- see https://github.com/nvim-treesitter/nvim-treesitter/discussions/8627#discussioncomment-16440673
    commit = "90cd6580e720caedacb91fdd587b747a6e77d61f",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})
      treesitter.install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
            vim.treesitter.start(args.buf)
            -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            -- vim.wo.foldmethod = "expr"
            -- indentation, provided by nvim-treesitter
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
        local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
        local filename = vim.fn.fnamemodify(filepath, ":t")
        return string.match(filename, ".*mise.*%.toml$") ~= nil
      end, { force = true, all = false })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-treesitter-textobjects").setup({
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
      })

      -- Helper to wrap a goto function with centering (only in normal and visual modes)
      local function goto_with_center(goto_fn, query, query_group)
        return function()
          goto_fn(query, query_group)
          local mode = vim.api.nvim_get_mode().mode
          if mode == "n" or mode == "v" or mode == "V" then
            vim.cmd("normal! zz")
          end
        end
      end

      local move = require("nvim-treesitter-textobjects.move")

      -- move
      vim.keymap.set(
        { "n", "x", "o" },
        "]]",
        goto_with_center(move.goto_next_start, "@class.outer", "textobjects"),
        { desc = "Next class start" }
      )
      vim.keymap.set(
        { "n", "x", "o" },
        "[[",
        goto_with_center(move.goto_previous_start, "@class.outer", "textobjects"),
        { desc = "Previous class start" }
      )
      vim.keymap.set(
        { "n", "x", "o" },
        "][",
        goto_with_center(move.goto_next_end, "@class.outer", "textobjects"),
        { desc = "Next class end" }
      )
      vim.keymap.set(
        { "n", "x", "o" },
        "[]",
        goto_with_center(move.goto_previous_end, "@class.outer", "textobjects"),
        { desc = "Previous class end" }
      )
      vim.keymap.set(
        { "n", "x", "o" },
        "]m",
        goto_with_center(move.goto_next_start, "@function.outer", "textobjects"),
        { desc = "Next function start" }
      )
      vim.keymap.set(
        { "n", "x", "o" },
        "[m",
        goto_with_center(move.goto_previous_start, "@function.outer", "textobjects"),
        { desc = "Previous function start" }
      )
      vim.keymap.set(
        { "n", "x", "o" },
        "]M",
        goto_with_center(move.goto_next_end, "@function.outer", "textobjects"),
        { desc = "Next function end" }
      )
      vim.keymap.set(
        { "n", "x", "o" },
        "[M",
        goto_with_center(move.goto_previous_end, "@function.outer", "textobjects"),
        { desc = "Previous function end" }
      )

      -- select
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end, { desc = "outer function" })
      vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end, { desc = "inner function" })
      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
      end, { desc = "outer class" })
      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
      end, { desc = "inner class" })

      -- swap
      vim.keymap.set("n", "<leader>a", function()
        require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
      end, { desc = "Swap parameter forward" })
      vim.keymap.set("n", "<leader>A", function()
        require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
      end, { desc = "Swap parameter backward" })
    end,
  },
}
