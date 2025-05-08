require("minuet").setup({
	virtualtext = {
		auto_trigger_ft = {
			"css",
			"em",
			"go",
			"graphql",
			"json",
			"lua",
			"python",
			"rust",
			"sql",
			"typescript",
			"yaml",
		},
		keymap = {
			accept = "<Leader>Y",
			accept_line = "<Leader>y",
			prev = "<Leader>z",
			next = "<Leader>x",
			dismiss = "<Leader>l",
		},
	},
	provider = "openai_fim_compatible",
	provider_options = {
		openai_fim_compatible = {
			api_key = "DEEPSEEK_API_KEY",
			name = "deepseek",
			optional = {
				max_tokens = 256,
				top_p = 0.9,
			},
		},
	},
})
