# Gistory

A tiny Neovim plugin to show the current file on a desired git branch
for quick comparisons

## Features

- shows the current file in a split tab on a desired git branch for a quick comparison
- supports syntax highlighting

TODO: quick pagination between commits?

## Installation

### Packer

```lua
use { "vdiezel/gistory.nvim" }
```

## Configuration

Require the package and call the `setup` package method:

```lua
local status_ok, gistory = pcall(require, "gistory")
if not status_ok then
  return
end

gistory.setup {
  default_branch = 'master', -- default: 'main'
  split_command = 'split'  -- default: 'vsplit'
}
```

## Commands
- shows the file on the default branch

```
:Gistory
```

- shows the file on a provided branch (mind the quotes)

```
:GistoryB "my-other-branch"
```

## Important

The plugin does not check out to the branch, but uses `git show` to find the file in the git history and writes it to a buffer. That means if you are using a git branch display in your UI, the branch name will not change when you focus the buffer. This might lead to confusion, therefore the hint.
