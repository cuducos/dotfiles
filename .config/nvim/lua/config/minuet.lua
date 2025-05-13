require("minuet").setup({
	virtualtext = {
		auto_trigger_ft = {},
		keymap = {
			accept = "<Leader>Y",
			accept_line = "<Leader>y",
			prev = "<Leader>z",
			next = "<Leader>x",
			dismiss = "<Leader>l",
		},
	},
	provider = "gemini",
})
