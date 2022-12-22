local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({ extensions = { file_browser = { hijack_netrw = true } } })
telescope.load_extension("file_browser")

local mappings = {
	{ "n", "<Leader>f", builtin.git_files },
	{ "n", "<Leader>F", builtin.find_files },
	{ "n", "<Leader>G", builtin.git_status },
	{ "n", "<Leader>b", builtin.buffers },
	{ "n", "<Leader>o", builtin.oldfiles },
	{ "n", "<Leader>/", builtin.live_grep },
	{ "n", "<Leader>m", builtin.keymaps },
	{ "n", "<leader>n", telescope.extensions.notify.notify },
	{ "n", "<leader>nt", telescope.extensions.file_browser.file_browser },
	{ "n", "<leader>ts", builtin.treesitter },
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

vim.cmd(
	"command! -nargs=? FindIn lua require('telescope.builtin').live_grep({type_filter = <f-args>, results_title = 'rg --type-list to show supported types'})"
)
