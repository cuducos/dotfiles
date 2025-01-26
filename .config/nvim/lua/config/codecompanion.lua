require("codecompanion").setup({
	display = { diff = { enabled = false } },
	strategies = {
		chat = { adapter = "openai" },
		inline = { adapter = "openai" },
	},
})
vim.keymap.set({ "n", "v" }, "<Leader>ci", "<cmd>CodeCompanion<cr>")
vim.keymap.set({ "n", "v" }, "<Leader>cc", "<cmd>CodeCompanionChat Toggle<cr>")
vim.cmd([[cab cc CodeCompanion]]) -- Expand 'cc' into 'CodeCompanion' in the command line
