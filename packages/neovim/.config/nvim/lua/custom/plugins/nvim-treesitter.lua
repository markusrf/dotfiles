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
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})

      -- Only call install() for parsers that aren't already present. install()
      -- spawns a job per parser even when up to date, which adds noticeable
      -- startup cost. Defer the work so it never blocks UIEnter.
      vim.schedule(function()
        local installed = treesitter.get_installed()
        local lookup = {}
        for _, p in ipairs(installed) do
          lookup[p] = true
        end
        local missing = {}
        for _, p in ipairs(parsers) do
          if not lookup[p] then
            table.insert(missing, p)
          end
        end
        if #missing > 0 then
          treesitter.install(missing)
        end
      end)

      -- Cache installed parsers; refresh after :TSUpdate or :TSInstall.
      local installed_cache = nil
      local function installed_set()
        if installed_cache then
          return installed_cache
        end
        installed_cache = {}
        for _, p in ipairs(treesitter.get_installed()) do
          installed_cache[p] = true
        end
        return installed_cache
      end

      local ts_group = vim.api.nvim_create_augroup("custom.treesitter", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = ts_group,
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang and installed_set()[lang] then
            vim.treesitter.start(args.buf)
            -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            -- vim.wo.foldmethod = "expr"
            -- indentation, provided by nvim-treesitter
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Bust the cache after parsers are installed/updated/removed.
      vim.api.nvim_create_autocmd("User", {
        group = ts_group,
        pattern = { "TSUpdate", "TSInstall", "TSUninstall" },
        callback = function()
          installed_cache = nil
        end,
      })

      -- Memoize per-bufnr; mise filename never changes for a given buffer
      -- without :BufFilePost firing.
      local mise_cache = {}
      vim.api.nvim_create_autocmd({ "BufFilePost", "BufWipeout" }, {
        group = ts_group,
        callback = function(args)
          mise_cache[args.buf] = nil
        end,
      })

      require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
        local buf = tonumber(bufnr) or 0
        local cached = mise_cache[buf]
        if cached ~= nil then
          return cached
        end
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
        local result = string.match(filename, ".*mise.*%.toml$") ~= nil
        mise_cache[buf] = result
        return result
      end, { force = true, all = false })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
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
