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

local system_command = function(commands)
  local result = vim.fn.system(commands)

  -- dont know enough if this is a good method for catching errors
  if vim.api.nvim_get_vvar("shell_error") ~= 0 then
    return false, '', result
  end

  return true, result, ''
end

local function get_git_file_path()
  local success, git_root, error = system_command({ 'git', 'rev-parse', '--show-toplevel' })

  if not success then
    return success, git_root, error
  end

  local git_root_trimmed = trim_whitespaces(git_root)
  local abs_file_path = vim.fn.expand('%')

  return success, '.' .. abs_file_path:gsub(git_root_trimmed, ''), error
end

local render = function(diff)
  local lines = {}

  for line in diff:gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
  end

  -- to remove additional empty line at the end
  -- coming from splitting the diff into lines
  -- when the last line ends with a new line character)
  local removedLine = table.remove(lines)

  -- in case the file was missing a new line character at the end
  -- we want to prevent deleting the last line
  -- (not sure yet that this really works as I want it to)
  if removedLine ~= '' then
    table.insert(lines, removedLine)
  end

  local buffer = vim.api.nvim_create_buf(true, true)
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

M.open_gistory = function(branch)
  local ok_git_file_name, file_name, error = get_git_file_path()

  if not ok_git_file_name then
    vim.api.nvim_echo({{ "Looking for git file failed: " .. error }}, false, {})
    return
  end

  local ok_diff, diff, error = system_command({ "git", "show", branch .. ':' .. file_name })

  if not ok_diff then
    vim.api.nvim_echo({{ "Showing diff failed: " .. error }}, false, {})
    return
  end

  render(diff)
end

return M
