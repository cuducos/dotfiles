vim.keymap.set("n", "<leader>g", function()
	require("neogit").open({ kind = "split" })
end)
