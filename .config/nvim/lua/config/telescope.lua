local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		layout_strategy = "vertical",
		layout_config = {
			vertical = { width = 0.99, height = 0.99 },
		},
	},
})
telescope.load_extension("live_grep_args")

local mappings = {
	{
		"n",
		"<Leader>f",
		function()
			vim.fn.system("git rev-parse --is-inside-work-tree")
			if vim.v.shell_error == 0 then
				builtin.git_files()
			else
				builtin.find_files({ hidden = true })
			end
		end,
	},
	{
		"n",
		"<Leader>F",
		function()
			builtin.find_files({ hidden = true, ignore = ".git/" })
		end,
	},
	{ "n", "<C-Space>", builtin.builtin },
	{ "n", "<Leader>G", builtin.git_status },
	{ "n", "<Tab><Tab>", builtin.buffers },
	{ "n", "<Leader>o", builtin.oldfiles },
	{ "n", "<Leader>k", builtin.keymaps },
	{ "n", "<Leader>n", telescope.extensions.notify.notify },
	{ "n", "<Leader>ts", builtin.treesitter },
	{ "n", "<Leader>lsp", builtin.lsp_document_symbols },
	{ "n", "<Leader>/", telescope.extensions.live_grep_args.live_grep_args },
	{ "v", "<Leader>/", require("telescope-live-grep-args.shortcuts").grep_visual_selection },
	{
		"n",
		"<Leader>df",
		function()
			builtin.find_files({
				search_dirs = { "~/.config", "~/Dropbox/Projects/dotfiles", "~/src/dotfiles" },
				hidden = true,
				follow = true,
			})
		end,
	},
}
for _, val in pairs(mappings) do
	vim.keymap.set(unpack(val))
end
