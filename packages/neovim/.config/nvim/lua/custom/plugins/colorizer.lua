return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    parsers = { css = true },
    display = {
      -- mode = "virtualtext",
      -- virtualtext = { position = "before" },
    },
  },
}
