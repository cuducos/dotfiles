local lsp = require("lsp")
require("rust-tools").setup({
	server = {
		on_attach = lsp.on_attach,
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
	tools = {
		inlay_hints = {
			only_current_line = true,
		},
	},
})
