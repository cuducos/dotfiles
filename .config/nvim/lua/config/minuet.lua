require("minuet").setup({
	virtualtext = {
		auto_trigger_ft = {},
		keymap = {
			accept = "<A-Tab>",
			next = "<A-S-Tab>",
		},
	},
	provider = "gemini",
})
vim.keymap.set({ "n" }, "<Leader>ai", "<cmd>Minuet virtualtext toggle<cr>")
