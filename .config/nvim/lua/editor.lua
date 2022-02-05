-- main editor configs
local api = vim.api
local opt = vim.opt
local g = vim.g

local function set_globals()
	g.mapleader = " "
	g.python3_host_prog = vim.loop.os_homedir() .. "/.virtualenvs/neovim/bin/python"
end

local function set_mappings()
	local opts = { noremap = true }
	local mappings = {
		{ "n", "<leader>,", "<Cmd>nohl<CR>", opts },
		{ "n", "<leader>ls", "'0<CR>", opts },
		{ "n", "<Leader>n", ":set relativenumber!<CR>", opts },
		-- buffer and aplist navigation
		{ "n", "<leader>h", "<C-w>h<CR>", opts },
		{ "n", "<leader>j", "<C-w>j<CR>", opts },
		{ "n", "<leader>k", "<C-w>k<CR>", opts },
		{ "n", "<leader>l", "<C-w>l<CR>", opts },
		{ "n", "<leader>Q", "<C-w>c<CR>", opts },
		{ "n", "<leader>w", "<Cmd>w<CR>", opts },
		{ "n", "<leader>z", "<Cmd>bp<CR>", opts },
		{ "n", "<leader>x", "<Cmd>bn<CR>", opts },
		{ "n", "<leader>qa", "<Cmd>bufdo bw<CR>", opts },
		{ "n", "<leader>q", "<Cmd>bw<CR>", opts },
		-- indent and keep selection
		{ "", ">", ">gv", {} },
		{ "", "<", "<gv", {} },
		-- move lines up and down
		{ "n", "<C-j>", ":m .+1<CR>==", opts },
		{ "n", "<C-k>", ":m .-2<CR>==", opts },
		{ "v", "J", ":m '>+1<CR>gv=gv", opts },
		{ "v", "K", ":m '<-2<CR>gv=gv", opts },
		-- disable arrows
		{ "n", "<up>", "<nop>", opts },
		{ "n", "<down>", "<nop>", opts },
		{ "n", "<left>", "<nop>", opts },
		{ "n", "<right>", "<nop>", opts },
		{ "i", "<up>", "<nop>", opts },
		{ "i", "<down>", "<nop>", opts },
		{ "i", "<left>", "<nop>", opts },
		{ "i", "<right>", "<nop>", opts },
		-- stop c, s and d from yanking
		{ "n", "c", [["_c]], opts },
		{ "x", "c", [["_c]], opts },
		{ "n", "s", [["_s]], opts },
		{ "x", "s", [["_s]], opts },
		{ "n", "d", [["_d]], opts },
		{ "x", "d", [["_d]], opts },
		-- stop p from overwtitting the register (by re-yanking it)
		{ "x", "p", "pgvy", opts },
		-- keep centered when n/N/J
		{ "n", "n", "nzz", opts },
		{ "n", "N", "Nzz", opts },
		{ "n", "J", "mzJ`z", opts },
		-- select the end of the line without linebreak
		{ "v", "$", "$h", opts },
	}

	for _, val in pairs(mappings) do
		api.nvim_set_keymap(unpack(val))
	end
end

local function set_options()
	local options = {
		autoindent = true,
		autoread = true,
		clipboard = "unnamed,unnamedplus",
		colorcolumn = "80,88,120",
		cursorline = true,
		expandtab = true,
		foldenable = false,
		hidden = true,
		ignorecase = true,
		mouse = "a",
		number = true,
		relativenumber = true,
		scrolloff = 5,
		shell = "/bin/bash",
		shiftwidth = 4,
		smartcase = true,
		smartindent = true,
		softtabstop = 4,
		splitbelow = true,
		splitright = true,
		tabstop = 4,
		termguicolors = true,
		wildignore = "*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite",
	}
	for key, val in pairs(options) do
		opt[key] = val
	end

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

	vim.cmd([[
    augroup MarkDownExts
      autocmd!
      autocmd BufNewFile,BufRead *.md setlocal ft=markdown " .md ->markdown
      autocmd BufNewFile,BufRead *.adoc setlocal ft=asciidoc " .adoc ->asciidoc
    augroup END
    ]])

	vim.cmd([[
    augroup Spell
        autocmd FileType rst,md,adoc setlocal spell spelllang=en_ca
        autocmd BufRead COMMIT_EDITMSG setlocal spell spelllang=en_ca
    augroup END
    ]])

	-- TODO is there a Lua API for those?
	vim.cmd([[
    cnoreabbrev W w
    cnoreabbrev W! w!
    cnoreabbrev Q q
    cnoreabbrev Q! q!
    cnoreabbrev Qa qa
    cnoreabbrev Qa! qa!
    cnoreabbrev Wq wq
    cnoreabbrev Wa wa
    cnoreabbrev WQ wq
    cnoreabbrev Wqa wqa
    ]])
end

set_globals()
set_mappings()
set_options()
