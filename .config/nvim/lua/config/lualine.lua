local function search_count()
	if vim.v.hlsearch == 0 then
		return ""
	end

	local result = vim.fn.searchcount({ maxcount = 999, timeout = 500 })
	local denominator = math.min(result.total, result.maxcount)
	return string.format(" %d of %d", result.current, denominator)
end

require("lsp-progress").setup()

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
	pattern = "LspProgressStatusUpdated",
	group = "lualine_augroup",
	callback = require("lualine").refresh,
})

require("lualine").setup({
	options = {
		theme = "catppuccin",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			"filetype",
			{
				"filename",
				path = 1,
				icon = "",
				symbols = {
					modified = "",
					readonly = "",
					unnamed = "¯\\_(ツ)_/¯",
					newfile = "", -- Text to show for new created file before first writting
				},
			},
		},
		lualine_x = {
			{
				require("lsp-progress").progress,
				hide = { "copilot", "null-ls", "ruby_lsp", "yamlls" },
			},
			search_count,
			"diagnostics",
			"fileformat",
			"encoding",
		},
		lualine_y = { "diff" },
		lualine_z = { "location", "progress" },
	},
})
