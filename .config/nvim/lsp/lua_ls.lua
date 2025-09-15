return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			completion = { callSnippet = "Replace" },
			hint = { enable = true },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
}
