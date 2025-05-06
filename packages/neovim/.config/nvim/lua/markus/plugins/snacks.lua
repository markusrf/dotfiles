return {
  "folke/snacks.nvim",
  dependencies = {
    "echasnovski/mini.icons",
  },
  priority = 1000,
  lazy = false,
  opts = {
    -- bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        {
          section = "terminal",
          cmd =
          "chafa ~/.config/nvim/dashboard-images/tropic_island_day.jpg --format symbols --symbols vhalf --stretch --size 64x16",
          height = 16,
          padding = 1,
        },
        {
          -- pane = 2,
          { section = "keys",   gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
    indent = { enabled = true },
    -- input = { enabled = true },
    -- git = { enabled = true },
    -- picker = { enabled = true },
    -- notifier = { enabled = true },
    quickfile = { enabled = true },
    -- scroll = { enabled = false },
    statuscolumn = { enabled = true },
    -- words = { enabled = true },
    animate = { enabled = true },
    bufdelete = { enabled = true },
  }
  -- keys = {
  --   { "<leader>sf",       function() Snacks.scratch() end,            desc = "Toggle Scratch Buffer" },
  --   { "<leader>S",        function() Snacks.scratch.select() end,     desc = "Select Scratch Buffer" },
  --   { "<leader>gl",       function() Snacks.lazygit.log_file() end,   desc = "Lazygit Log (cwd)" },
  --   { "<leader>lg",       function() Snacks.lazygit() end,            desc = "Lazygit" },
  --   { "<C-p>",            function() Snacks.picker.pick("files") end, desc = "Find Files" },
  --   { "<leader><leader>", function() Snacks.picker.recent() end,      desc = "Recent Files" },
  --   { "<leader>fb",       function() Snacks.picker.buffers() end,     desc = "Buffers" },
  --   { "<leader>fg",       function() Snacks.picker.grep() end,        desc = "Grep Files" },
  --   { "<C-n>",            function() Snacks.explorer() end,           desc = "Explorer" },
  -- }
}
