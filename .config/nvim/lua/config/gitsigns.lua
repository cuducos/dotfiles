require("gitsigns").setup({
	numhl = true,
	on_attach = function(bufnr)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"]h",
			"&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'",
			{ noremap = true, expr = true }
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"[h",
			"&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'",
			{ noremap = true, expr = true }
		)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>hs", ":Gitsigns stage_hunk<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(bufnr, "v", "<leader>hs", ":Gitsigns stage_hunk<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>hr", ":Gitsigns reset_hunk<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(bufnr, "v", "<leader>hr", ":Gitsigns reset_hunk<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>hb",
			"<cmd>Gitsigns toggle_current_line_blame<CR>",
			{ noremap = true }
		)
	end,
})
