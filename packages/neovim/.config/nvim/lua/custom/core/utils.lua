local M = {}

math.randomseed((vim.uv or vim.loop).hrtime())

-- Chooses a random item from a list
-- @param list array
M.choose = function(list)
  return list[math.random(#list)]
end

return M
