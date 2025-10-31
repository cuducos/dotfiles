local extras = {
	"When replying with code, the code must:",
	"- Be modern production-ready, clean and expressive code",
	"- Use code optimized for computational resources (memory and CPU)",
	"- Avoid useless comments, the code should be expressive by itself",
	"- Use meanignless variable/function/method names",
	"- If in Python, avoid generic imports as `import foo` (use `from foo import bar` instead)",
	"- If in Go, keep scope variable names short",
}

require("codecompanion").setup({
	display = { diff = { enabled = false } },
	adapters = {
		http = {
			["deepseek-chat"] = function()
				return require("codecompanion.adapters.http").extend("deepseek", {
					schema = { model = { default = "deepseek-chat" } },
				})
			end,
		},
	},
	strategies = {
		chat = { adapter = "deepseek-chat" },
		inline = { adapter = "deepseek-chat" },
	},
	opts = {
		system_prompt = function(ctx)
			return ctx.default_system_prompt .. extras
		end,
	},
})

vim.keymap.set({ "n", "v" }, "<Leader>ci", "<cmd>CodeCompanion<cr>")
vim.keymap.set({ "n", "v" }, "<Leader>cc", "<cmd>CodeCompanionChat Toggle<cr>")
