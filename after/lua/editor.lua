-- main editor configs
local api = vim.api
local opt = vim.opt

local function set_globals()
  vim.g.python3_host_prog = "~/.virtualenvs/neovim/bin/python"
  vim.g.python_host_prog = "~/.virtualenvs/neovim.old/bin/python"
  vim.g.loaded_netrwPlugin = 1
  vim.g.mapleader = " "
end

local function set_options()
  local options = {
    termguicolors = true,
    cursorline = true,
    number = true,
    relativenumber = true,
    mouse = "a",
    colorcolumn = "80",
    scrolloff = 5,
    splitbelow = true,
    splitright = true,
    hidden = true,
    ignorecase = true,
    smartcase = true,
    wildignore = "*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite",
    expandtab = true,
    autoindent = true,
    smartindent = true,
    shiftwidth = 4,
    softtabstop = 4,
    tabstop = 4,
  }
  for key, val in pairs(options) do
    opt[key] = val
  end

  vim.g.gruvbox_invert_selection = false
  vim.cmd("colorscheme gruvbox")

  vim.cmd([[
  augroup LineNumbers		
    autocmd!
    autocmd InsertEnter  * set relativenumber
    autocmd FocusGained * set relativenumber
    autocmd BufEnter * set relativenumber
    autocmd InsertLeave * set norelativenumber
    autocmd BufLeave * set norelativenumber
    autocmd FocusLost * set norelativenumber
  augroup END
  ]])
end

set_globals()
set_options()
