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

telescope.load_extension("advanced_git_search")

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
	{ "n", "<Leader>/", builtin.live_grep },
	{ "n", "<Leader>k", builtin.keymaps },
	{ "n", "<leader>n", telescope.extensions.notify.notify },
	{ "n", "<leader>ts", builtin.treesitter },
	{ "n", "<leader>lr", builtin.lsp_references },
	{
		"n",
		"<leader>gb",
		function()
			require("gitsigns").toggle_current_line_blame()
			telescope.extensions.advanced_git_search.diff_commit_file()
		end,
	},
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

vim.cmd("command! -nargs=? FindInDir lua require('telescope.builtin').live_grep({search_dirs = { <f-args> }})")
vim.cmd(
	"command! -nargs=? FindByType lua require('telescope.builtin').live_grep({type_filter = <f-args>, results_title = 'rg --type-list to show supported types'})"
)
