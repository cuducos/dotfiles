-- formatter modules
local function prettier()
	return {
		exe = "prettier",
		args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
		stdin = true,
	}
end

require("formatter").setup({
	logging = false,
	filetype = {
		elm = {
			function()
				return { exe = "elm-format", args = { "--stdin" }, stdin = true }
			end,
		},
		go = {
			function()
				return { exe = "gofmt", stdin = true }
			end,
			function()
				return { exe = "goimports", stdin = true }
			end,
		},
		javascript = { prettier },
		javascriptreact = { prettier },
		json = {
			function()
				return {
					exe = "prettier",
					args = {
						"--stdin-filepath",
						vim.api.nvim_buf_get_name(0),
						"--parser",
						"json",
					},
					stdin = true,
				}
			end,
		},
		lua = {
			function()
				return {
					exe = "stylua",
					args = {
						"-",
					},
					stdin = true,
				}
			end,
		},
		markdown = { prettier },
		python = {
			function()
				return { exe = "black", args = { "-q", "-" }, stdin = true }
			end,
		},
		ruby = {
			function()
				return {
					exe = "rubocop",
					stdin = true,
					args = {
						"--stdin",
						vim.api.nvim_buf_get_name(0),
						"--stderr",
						"--auto-correct-all",
					},
				}
			end,
		},
		rust = {
			function()
				return { exe = "rustfmt", args = { "--emit=stdout" }, stdin = true }
			end,
		},
	},
})

local format_on_save = vim.api.nvim_create_augroup("FormatOnSave", {})
vim.api.nvim_create_autocmd(
	"BufWritePost",
	{ group = format_on_save, pattern = { "*.elm", "*.go", "*.rs" }, command = "FormatWrite" }
)

vim.keymap.set("n", "<leader>af", "<Cmd>Format<CR>")
