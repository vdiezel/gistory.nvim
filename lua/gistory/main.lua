local M = {}

M.set_config = function(config)
  M.config = config
end

M.open_gistory_default = function()
  M.open_gistory(M.config.default_branch)
end

local function trim_whitespaces(s)
  return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end

local function get_git_file_path()
  local handle_git_root = io.popen('git rev-parse --show-toplevel')

  if handle_git_root == nil then
    return
  end

  local git_root = trim_whitespaces(handle_git_root:read('*a'))
  local abs_file_path = vim.fn.expand('%')

  return '.' .. abs_file_path:gsub(git_root, '')
end

M.open_gistory = function(branch)
  local command = 'git show ' .. branch ..':' .. get_git_file_path()
  local handle = io.popen(command)

  if (handle == nil) then
    return
  end

  local output = handle:read("*a")

  local lines = {}
  local totalLines = 0

  for line in output:gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
    totalLines = totalLines + 1
  end

  -- to remove additional empty line at the end
  local removedLine = table.remove(lines)

  -- in case the file was missing a new line character at the end
  -- we want to prevent deleting the last line
  -- (not sure yet that this really works as I want it to)
  if removedLine ~= '' then
    table.insert(lines, removedLine)
  end

  local buffer = vim.api.nvim_create_buf(true, true)

  -- this still adds an empty line at the end of the buffer ...
  vim.api.nvim_buf_set_lines(buffer, 0, -1, true, lines)

  -- preserve filetype to get syntax highlighting
  local filetype = vim.bo.filetype

  vim.api.nvim_command(M.config.split_command)

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buffer)

  vim.api.nvim_buf_set_option(buffer, "bufhidden", 'wipe')
  vim.api.nvim_buf_set_option(buffer, "modifiable", false)
  vim.api.nvim_command('setfiletype ' .. filetype)
end

return M
