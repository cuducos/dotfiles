require("codecompanion").setup({
	display = { diff = { enabled = false } },
	strategies = {
		chat = { adapter = "deepseek" },
		inline = { adapter = "deepseek" },
	},
})
vim.keymap.set({ "n", "v" }, "<Leader>ci", "<cmd>CodeCompanion<cr>")
vim.keymap.set({ "n", "v" }, "<Leader>cc", "<cmd>CodeCompanionChat Toggle<cr>")
