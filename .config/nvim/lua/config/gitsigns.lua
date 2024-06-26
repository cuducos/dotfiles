local opts = { noremap = true, buffer = true }

require("gitsigns").setup({
	signs = {
		add = { text = "" },
		change = { text = "" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "" },
		untracked = { text = "┆" },
	},
	numhl = true,
	current_line_blame_opts = {
		virt_text_pos = "right_align",
	},
	on_attach = function(_)
		vim.keymap.set("n", "[g", require("gitsigns").next_hunk, opts)
		vim.keymap.set("n", "]g", require("gitsigns").prev_hunk, opts)
		vim.keymap.set("n", "<Leader>hp", require("gitsigns").preview_hunk, opts)
		vim.keymap.set("n", "<Leader>hs", require("gitsigns").stage_hunk, opts)
		vim.keymap.set("n", "<Leader>hr", require("gitsigns").reset_hunk, opts)
		vim.keymap.set("n", "<Leader>hu", require("gitsigns").undo_stage_hunk, opts)
		vim.keymap.set("n", "<Leader>hb", require("gitsigns").toggle_current_line_blame, opts)
	end,
})
