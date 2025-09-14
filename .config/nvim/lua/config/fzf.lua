local fzf = require("fzf-lua")

fzf.setup({})

local keymaps = {
	{ "<Leader>F", fzf.files },
	{ "<Tab><Tab>", fzf.buffers },
	{ "<Leader>o", fzf.oldfiles },
	{ "<Leader>k", fzf.keymaps },
	{ "<Leader>lsp", fzf.lsp_live_workspace_symbols },
	{ "<Leader>r", fzf.lsp_references },
	{ "<Leader>/", fzf.grep },
	{ "<Leader>s", fzf.builtin },
	{ "<Leader>r", fzf.resume },
	{
		"<Leader>f",
		function()
			local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree")
			if vim.v.shell_error == 0 then
				fzf.git_files()
			else
				fzf.files()
			end
		end,
	},
	{
		"<Leader>df",
		function()
			fzf.files({
				cwd = "~/Dropbox/Projects/dotfiles",
				hidden = true,
			})
		end,
	},
}
for _, map in ipairs(keymaps) do
	vim.keymap.set("n", map[1], map[2], { noremap = true, silent = true })
end
