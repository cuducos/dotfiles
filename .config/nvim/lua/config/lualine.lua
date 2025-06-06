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

local location_with_total_chars = function()
	return string.format("%d:%d (%d)", vim.fn.line("."), vim.fn.col("."), vim.fn.wordcount().chars)
end

local lsp_progress_or_yaml_key_value = function()
	if vim.bo.filetype == "yaml" then
		local yaml = require("yaml_nvim")
		local options = { yaml.get_yaml_key_and_value, yaml.get_yaml_key }
		for _, func in ipairs(options) do
			local path = func()
			if string.len(path) <= 80 then
				return path
			end
		end
		return ""
	end

	return require("lsp-progress").progress()
end

require("lualine").setup({
	options = {
		theme = "catppuccin",
	},
	sections = {
		lualine_a = { require("minuet.lualine"), "mode" },
		lualine_b = { "branch", "filetype" },
		lualine_c = {
			{
				"filename",
				path = 1,
				icon = "",
				symbols = {
					modified = "",
					readonly = "",
					unnamed = "¯\\_(ツ)_/¯",
					newfile = "", -- Text to show for new created file before first writing
				},
			},
		},
		lualine_x = {
			{ lsp_progress_or_yaml_key_value, hide = { "copilot", "null_ls" } },
			search_count,
			"diagnostics",
		},
		lualine_y = { "fileformat", "encoding", "diff" },
		lualine_z = { location_with_total_chars, "progress" },
	},
})
