local M = {}

-- Chooses a random item from a list
-- @param list array
M.choose = function(list)
  math.randomseed(os.time())
  return list[math.random(#list)]
end

return M
