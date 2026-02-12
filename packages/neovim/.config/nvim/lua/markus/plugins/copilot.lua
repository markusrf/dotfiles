return {
  "zbirenbaum/copilot.lua",
  dependencies = { "copilotlsp-nvim/copilot-lsp" },
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = false,
        keymap = {
          accept = "<C-enter>",
          accept_word = "<C-S-enter>",
          accept_line = false,
          next = "<C-S-j>",
          prev = "<C-S-k>",
          dismiss = "<C-Esc>",
        },
      },
      server_opts_overrides = {
        settings = {
          telemetry = { telemetryLevel = "off" },
        },
      },
    })
    vim.keymap.set("n", "<leader>ct", function()
      require("copilot.suggestion").toggle_auto_trigger()
    end, { desc = "Toggle Copilot auto suggestion" })
  end,
}
