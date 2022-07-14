local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup()
local mappings = {
	{ "n", "<Leader>f", builtin.git_files },
	{ "n", "<Leader>G", builtin.git_status },
	{ "n", "<Leader>b", builtin.buffers },
	{ "n", "<Leader>o", builtin.oldfiles },
	{ "n", "<Leader>/", builtin.live_grep },
	{ "n", "<Leader>m", builtin.keymaps },
	{ "n", "<leader>n", telescope.extensions.notify.notify },
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
