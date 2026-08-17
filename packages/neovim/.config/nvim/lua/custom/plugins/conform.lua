return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  keys = {
    {
      "<leader>gf",
      function()
        require("conform").format()
      end,
      desc = "Format using conform",
    },
  },
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
      },
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
    })
  end,
}
