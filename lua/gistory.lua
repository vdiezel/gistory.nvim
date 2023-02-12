local M = {}
local main = require('gistory.main')

local default_config = {
  default_branch = 'main',
  split_command = 'vsplit'  -- ['split', 'vsplit']
}

M.setup = function(opts)
  M.config = vim.tbl_deep_extend('force', default_config, opts or {})
  main.set_config(M.config)
end

return M
