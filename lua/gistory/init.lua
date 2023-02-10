local M = {}

M.open_gistory = function(branch)
  branch = branch or "main"

  vim.api.nvim_command('vsplit')
  local win = vim.api.nvim_get_current_win()
  local buffer = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, buffer)
  vim.api.nvim_buf_set_option(buffer, "bufhidden", 'wipe')
  vim.api.nvim_buf_set_option(buffer, "modifiable", false)
end

return M
