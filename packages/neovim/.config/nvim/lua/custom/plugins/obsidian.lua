local obsidian_augroup = vim.api.nvim_create_augroup("ObsidianKeymaps", { clear = true })

local obsidian_keymaps = {
  { "n", "<leader>ot", "<cmd>Obsidian tags<CR>", "Obsidian: Tags" },
  { "n", "<leader>ob", "<cmd>Obsidian backlinks<CR>", "Obsidian: Backlinks" },
  { "n", "<leader>oh", "<cmd>Obsidian toc<CR>", "Obsidian: Headings" },
  { "n", "<leader>or", "<cmd>Obsidian rename<CR>", "Obsidian: Rename" },
}

return {
  "obsidian-nvim/obsidian.nvim",
  ft = "markdown",
  config = function()
    require("obsidian").setup({
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
    })
    -- TODO: v3.14 supports using lsp keybinds instead of these
    -- but the on_attach function in lsp.lua is not run when obsidian_ls starts
    vim.api.nvim_create_autocmd("User", {
      group = obsidian_augroup,
      pattern = "ObsidianNoteEnter",
      callback = function(ev)
        for _, km in ipairs(obsidian_keymaps) do
          local mode, keys, func, desc = km[1], km[2], km[3], km[4]
          vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = desc })
        end
      end,
    })
  end,
}
