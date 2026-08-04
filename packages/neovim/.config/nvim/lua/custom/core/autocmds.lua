vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "obsidian" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "Cyan" })

-- Rebuild stale/missing personal-dictionary .add.spl files at startup.
-- Vim only auto-updates .add.spl via zg/zw; manual edits or deletions of
-- the .add (or .add.spl) are NOT picked up on load and need :mkspell. This does
-- that automatically when the .add.spl is missing or older than its .add source.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    for _, add in ipairs(vim.opt.spellfile:get()) do
      local spl = add .. ".spl"
      local a = vim.uv.fs_stat(add)
      local s = vim.uv.fs_stat(spl)
      if a and (not s or s.mtime.sec < a.mtime.sec) then
        pcall(vim.cmd, ("silent! mkspell! %s %s"):format(vim.fn.fnameescape(spl), vim.fn.fnameescape(add)))
      end
    end
  end,
})
