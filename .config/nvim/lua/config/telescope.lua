local actions = require("telescope.actions")
require("telescope").setup({ defaults = { mappings = { i = { ["<Esc>"] = actions.close } } } })

_G.find_dotfiles = function()
	require("telescope.builtin").find_files({
		search_dirs = { "~/Dropbox/Projects/dotfiles", "~/src/dotfiles" },
		hidden = true,
		follow = true,
	})
end

local mappings = {
	{ "n", "<Leader>f", [[<Cmd>Telescope git_files<CR>]] },
	{ "n", "<Leader>G", [[<Cmd>Telescope git_status<CR>]] },
	{ "n", "<Leader>e", [[<Cmd>Telescope find_files<CR>]] },
	{ "n", "<Leader>b", [[<Cmd>Telescope buffers<CR>]] },
	{ "n", "<Leader>o", [[<Cmd>Telescope oldfiles<CR>]] },
	{ "n", "<Leader>/", [[<Cmd>Telescope live_grep<CR>]] },
	{ "n", "<Leader>m", [[<Cmd>Telescope keymaps<CR>]] },
	{ "n", "<Leader>df", [[<Cmd>lua find_dotfiles()<CR>]] },
}
for _, val in pairs(mappings) do
	vim.keymap.set(unpack(val))
end
