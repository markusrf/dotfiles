return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
        javascript = { "biome-check" },
        javascriptreact = { "biome-check" },
        typescript = { "biome-check" },
        typescriptreact = { "biome-check" },
        json = { "biome-check" },
        css = { "biome-check" },
        terraform = { "terraform_fmt" },
        sh = { "shellcheck" },
        zsh = { "shellcheck" },
        sql = { "sql_formatter" },
        -- markdown = { "codespell" },
        -- text = { "codespell" },
      },
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
    })

    vim.keymap.set("n", "<leader>gf", conform.format, { desc = "Format using conform" })
  end,
}
