local setup_snippets = function()
  -- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#lua
  local ls = require("luasnip")
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node

  ls.add_snippets("python", {
    s("def", {
      t("def "),
      i(1, "foo"),
      t("("),
      i(2),
      t(") -> "),
      i(3, "None"),
      t({ ":", "" }),
      t("    "),
      i(4, "pass"),
    }),
  })
end

return {
  "saadparwaiz1/cmp_luasnip",
  event = "InsertEnter",
  config = function()
    local ls = require("luasnip")
    vim.keymap.set({ "i", "s" }, "<C-l>", function()
      ls.jump(1)
    end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-h>", function()
      ls.jump(-1)
    end, { silent = true })

    setup_snippets()
  end,
}
