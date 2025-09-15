local line_numbers = vim.api.nvim_create_augroup("LineNumbers", {})
local set_relative = { "InsertLeave", "FocusGained", "BufEnter", "CmdlineLeave", "WinEnter" }
for _, value in pairs(set_relative) do
	vim.api.nvim_create_autocmd(value, { group = line_numbers, pattern = "*", command = "set relativenumber" })
end
local set_non_relative = { "InsertEnter", "FocusLost", "BufLeave", "CmdlineEnter", "WinLeave" }
for _, value in pairs(set_non_relative) do
	vim.api.nvim_create_autocmd(value, { group = line_numbers, pattern = "*", command = "set norelativenumber" })
end

local markdown_filetypes = vim.api.nvim_create_augroup("MarkdownExtensions", {})
local markdown_extensions = { "md", "adoc" }
for _, ext in pairs(markdown_extensions) do
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
