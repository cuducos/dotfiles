local go_to_github_repo = function()
	local repo = vim.fn.expand("<cfile>")
	if not string.find(repo, "^[a-zA-Z0-9-_.]*/[a-zA-Z0-9-_.]*$") then
		return
	end

	local url = "https://github.com/" .. repo
	local cmd = "xdg-open"
	if vim.fn.has("mac") == 1 then
		cmd = "open"
	end

	vim.fn.jobstart({ cmd, url }, { detach = true })
end

local function set_globals()
	vim.g.mapleader = " "
	vim.g.python3_host_prog = vim.loop.os_homedir() .. "/.virtualenvs/neovim/bin/python"
end

local function set_mappings()
	local mappings = {
		{ "n", "<Leader>,", "<Cmd>nohl<CR>" },
		{ "n", "<Leader>#", ":set relativenumber!<CR>" },
		{ "n", "<Leader>w", ":w<CR>" },
		{ "n", "vv", "viw" },
		{ "n", "<Leader>gh", go_to_github_repo },
		-- buffer and split management
		{ "n", "<Leader>Q", "<C-w>c<CR>" },
		{ "n", "<Leader>qa", "<Cmd>bufdo bw<CR>" },
		{ "n", "<Leader>q", "<Cmd>bw<CR>" },
		-- move horizontally between splits
		{ "n", "H", "<C-w>h" },
		{ "n", "L", "<C-w>l" },
		-- indent and keep selection
		{ "", ">", ">gv", {} },
		{ "", "<", "<gv", {} },
		-- move lines up and down
		{ "n", "<C-j>", ":m .+1<CR>==" },
		{ "n", "<C-k>", ":m .-2<CR>==" },
		{ "v", "J", ":m '>+1<CR>gv=gv" },
		{ "v", "K", ":m '<-2<CR>gv=gv" },
		-- stop c, s and d from yanking
		{ "n", "c", [["_c]] },
		{ "x", "c", [["_c]] },
		{ "n", "s", [["_s]] },
		{ "x", "s", [["_s]] },
		{ "n", "d", [["_d]] },
		{ "x", "d", [["_d]] },
		-- stop p from overwtitting the register (by re-yanking it)
		{ "x", "p", "pgvy" },
		-- keep centered when n/N/J
		{ "n", "n", "nzz" },
		{ "n", "N", "Nzz" },
		{ "n", "J", "mzJ`z" },
		-- select the end of the line without linebreak
		{ "v", "$", "$h" },
	}
	for _, val in pairs(mappings) do
		vim.keymap.set(unpack(val))
	end
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function set_options()
	local options = {
		autoindent = true,
		autoread = true,
		clipboard = "unnamed,unnamedplus",
		colorcolumn = "80",
		cursorline = true,
		expandtab = true,
		foldenable = false,
		foldmethod = "expr",
		foldexpr = "nvim_treesitter#foldexpr()",
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
		laststatus = 3,
		updatetime = 500,
		completeopt = "menu,menuone,preview,noselect",
		shortmess = vim.opt.shortmess + "c",
	}
	for key, val in pairs(options) do
		vim.opt[key] = val
	end

	local line_numbers = vim.api.nvim_create_augroup("LineNumbers", {})
	local set_relative = { "InsertLeave", "FocusGained", "BufEnter", "CmdlineLeave", "WinEnter" }
	for _, value in pairs(set_relative) do
		vim.api.nvim_create_autocmd(value, { group = line_numbers, pattern = "*", command = "set relativenumber" })
	end
	local set_non_relative = { "InsertEnter", "FocusLost", "BufLeave", "CmdlineEnter", "WinLeave" }
	for _, value in pairs(set_non_relative) do
		vim.api.nvim_create_autocmd(value, { group = line_numbers, pattern = "*", command = "set norelativenumber" })
	end

	local markdown_filetypes = vim.api.nvim_create_augroup("MarkdownExtentions", {})
	local markdown_extentions = { "md", "adoc" }
	for _, ext in pairs(markdown_extentions) do
		vim.api.nvim_create_autocmd(
			{ "BufNewFile", "BufRead" },
			{ group = markdown_filetypes, pattern = "*." .. ext, command = "setlocal ft=markdown" }
		)
	end

	local spell_check = vim.api.nvim_create_augroup("SpellCheck", {})
	vim.api.nvim_create_autocmd(
		"FileType",
		{ group = spell_check, pattern = { "rst", "md", "adoc" }, command = "setlocal spell spelllang=en_ca" }
	)
	vim.api.nvim_create_autocmd(
		"BufRead",
		{ group = spell_check, pattern = "COMMIT_EDITMSG", command = "setlocal spell spelllang=en_ca" }
	)

	vim.filetype.add({
		extension = {
			ejson = "json",
		},
	})

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

    iabbrev /t <ESC>oTODO<ESC><ESC><ESC>VgckJ$a
    iabbrev /r <ESC>oTODO: remove<ESC><ESC><ESC>VgckJ$a
    iabbrev byebug binding.pry
    ]])
end

set_globals()
set_mappings()
set_options()

local colorcolumns_by_filetype = {
	python = "88",
	ruby = "120",
	gitcommit = "72",
}

for ft, len in pairs(colorcolumns_by_filetype) do
	vim.api.nvim_create_autocmd({ "FileType" }, {
		pattern = ft,
		command = "setlocal colorcolumn=" .. len,
	})
end
