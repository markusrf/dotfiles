return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    parsers = {
      css = true,
      names = false,
      hex = {
        rgb = false,
        rgba = false,
      },
    },
    display = {
      mode = "virtualtext",
      virtualtext = {
        char = "󱓻",
        position = "before",
      },
    },
  },
}
