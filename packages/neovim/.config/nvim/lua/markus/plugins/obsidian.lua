local function create_keymap(mode, keys, func, desc)
  vim.api.nvim_create_autocmd("User", {
    pattern = "ObsidianNoteEnter",
    callback = function(ev)
      vim.keymap.set(mode, keys, func, {
        buffer = ev.buf,
        desc = desc,
      })
    end,
  })
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  config = function()
    require("obsidian").setup(
      {
        ui = {
          enable = false, -- not compatible with render-markdown.nvim, see help *render-markdown-info-obsidian.nvim*
        },
        legacy_commands = false,
        workspaces = {
          {
            name = "personal",
            path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/vault",
          },
        },
      }
    )
    -- TODO: v3.14 supports using lsp keybinds instead of these
    -- but the on_attach function in lsp.lua is not run when obsidian_ls starts
    create_keymap("n", "<leader>ot", "<cmd>Obsidian tags<CR>", "Obsidian: Tags")
    create_keymap("n", "<leader>ob", "<cmd>Obsidian backlinks<CR>", "Obsidian: Backlinks")
    create_keymap("n", "<leader>oh", "<cmd>Obsidian toc<CR>", "Obsidian: Headings")
    create_keymap("n", "<leader>or", "<cmd>Obsidian rename<CR>", "Obsidian: Rename")
  end,
}
