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

local beginning_of_the_line = function()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = cursor[1]
	local column = cursor[2]
	local contents = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
	local text = string.sub(contents, 1, column - 1)

	if string.match(text, "^[%s\t]*$") ~= nil then
		vim.api.nvim_win_set_cursor(0, { line, 0 })
	else
		vim.api.nvim_feedkeys("^", "n", false)
	end
end

local function toggle_relative_number()
	vim.o.relativenumber = not vim.o.relativenumber
end

local function set_globals()
	vim.g.mapleader = " "
	vim.g.python3_host_prog = vim.loop.os_homedir() .. "/.virtualenvs/neovim/bin/python"
end

local function set_mappings()
	local mappings = {
		{ "n", "<Leader>,", "<Cmd>nohl<CR>" },
		{ "n", "#", toggle_relative_number },
		{ "n", "<Leader>w", ":w<CR>" },
		{
			"n",
			"<Leader>wq",
			function()
				vim.cmd("w")
				vim.cmd("bd")
			end,
		},
		{ "n", "vv", "viw" },
		{ "n", "gh", go_to_github_repo },
		{ "n", "0", beginning_of_the_line },
		-- buffer and split management
		{ "n", "<Leader>qa", "<Cmd>bufdo bw<CR>" },
		{ "n", "<Leader>q", "<Cmd>bw<CR>" },
		{ "n", "<Home>", "<C-w>h" },
		{ "n", "<End>", "<C-w>l" },
		{ "n", "<PageUp>", "<C-w>k" },
		{ "n", "<PageDown>", "<C-w>j" },
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

local function disable_folding()
	local fold_keys = { "zf", "zF", "zd", "zE", "za", "zA", "zo", "zO", "zc", "zC", "zx", "zX", "zm", "zM", "zr", "zR" }
	for _, key in ipairs(fold_keys) do
		local existing_map = vim.fn.maparg(key, "n")
		if existing_map ~= "" then
			vim.keymap.del("n", key)
		end
	end
	if vim.fn.maparg("zf", "v") ~= "" then
		vim.keymap.del("v", "zf")
	end
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function set_options()
	local options = {
		autoindent = true,
		autoread = true,
		swapfile = false,
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
    ]])
end

set_globals()
set_mappings()
set_options()
disable_folding()

local colorcolumns_by_filetype = {
	python = "88",
	gitcommit = "72",
}

for ft, len in pairs(colorcolumns_by_filetype) do
	vim.api.nvim_create_autocmd({ "FileType" }, {
		pattern = ft,
		command = "setlocal colorcolumn=" .. len,
	})
end

vim.keymap.set("n", "<cr>", function()
	local path = vim.fn.expand("<cfile>")
	local buf = vim.api.nvim_get_current_buf()
	local cwd = vim.api.nvim_buf_get_name(buf):match("(.*/)")

	local handler = io.open(cwd .. path)
	if handler == nil then
		return "<cr>"
	end

	handler:close()
	return "gF"
end, {})

vim.keymap.set("n", "<Leader>st", function()
	if vim.bo.filetype ~= "python" then
		return
	end

	local parts = { "import pytest", "pytest.set_trace()" }
	local cmd = table.concat(parts, "; ")

	local cleaned = vim.api.nvim_get_current_line():match("^%s*(.-)%s*$")
	if cleaned == parts[1] or cleaned == parts[2] or cleaned == cmd then
		local bufnr = vim.api.nvim_get_current_buf()
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		for i = #lines, 1, -1 do
			local line = lines[i]:match("^%s*(.-)%s*$")
			if line == parts[1] or line == parts[2] or line == cmd then
				vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, {})
			end
		end
	else
		local _, col = unpack(vim.api.nvim_win_get_cursor(0))
		local current_line = vim.api.nvim_get_current_line()
		local new_line = current_line:sub(1, col) .. " " .. cmd .. current_line:sub(col + 1)
		vim.api.nvim_set_current_line(new_line)
	end
end)
