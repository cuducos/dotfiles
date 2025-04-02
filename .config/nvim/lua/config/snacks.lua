local snacks = require("snacks")
local mappings = {
	{ "n", "<Leader>F", snacks.picker.files },
	{ "n", "<Tab><Tab>", snacks.picker.buffers },
	{ "n", "<Leader>o", snacks.picker.recent },
	{ "n", "<Leader>k", snacks.picker.keymaps },
	{ "n", "<Leader>n", snacks.picker.notifications },
	{ "n", "<Leader>ts", snacks.picker.treesitter },
	{ "n", "<Leader>lsp", snacks.picker.lsp_symbols },
	{ "n", "<Leader>r", snacks.picker.lsp_references },
	{ "n", "<Leader>/", snacks.picker.grep },
	{
		"n",
		"<Leader>s",
		function()
			snacks.picker()
		end,
	},
	{
		"n",
		"<Leader>f",
		function()
			vim.fn.system("git rev-parse --is-inside-work-tree")
			if vim.v.shell_error == 0 then
				snacks.picker.git_files()
			else
				snacks.picker.smart()
			end
		end,
	},
	{
		"n",
		"<Leader>df",
		function()
			snacks.picker.files({
				dirs = { "~/Dropbox/Projects/dotfiles", "~/.config" },
				follow = true,
				hidden = true,
			})
		end,
	},
}
for _, val in pairs(mappings) do
	vim.keymap.set(unpack(val))
end
