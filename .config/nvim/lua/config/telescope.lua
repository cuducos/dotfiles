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

local is_another_file_buffer = function(buf, current)
	if buf == current then
		return false
	end
	if vim.api.nvim_buf_get_option(buf, "buftype") ~= "" then
		return false
	end
	if vim.api.nvim_buf_get_name(buf) == "" then
		return false
	end
	if not vim.api.nvim_buf_get_option(buf, "swapfile") then
		return false
	end

	return true
end

local other_file_buffers = function()
	local buffers = vim.api.nvim_list_bufs()
	if #buffers < 2 then
		return {}
	end

	local current = vim.api.nvim_get_current_buf()
	local other = {}
	for _, buf in pairs(buffers) do
		if is_another_file_buffer(buf, current) then
			table.insert(other, buf)
		end
	end
	return other
end

local open_buffer_in = function(cmd)
	local buffers = other_file_buffers()
	if #buffers == 0 then
		return
	end
	if #buffers == 1 then
		vim.cmd(cmd .. " " .. vim.api.nvim_buf_get_name(buffers[1]))
		return
	end

	local labels = { split = "horizontal", vsplit = "vertical" }
	local entry = function(buf)
		return {
			value = buf,
			display = vim.api.nvim_buf_get_name(buf),
			ordinal = vim.api.nvim_buf_get_name(buf),
		}
	end

	local mapping = function(prompt_bufnr, map)
		map("i", "<CR>", function()
			local selection = require("telescope.actions.state").get_selected_entry()
			require("telescope.actions").close(prompt_bufnr)
			vim.cmd(cmd .. " " .. vim.api.nvim_buf_get_name(selection.value))
		end)
		return true
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Select a buffer to open in the " .. labels[cmd] .. " split",
			finder = require("telescope.finders").new_table({ results = buffers, entry_maker = entry }),
			sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
			attach_mappings = mapping,
		})
		:find()
end

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
	{ "n", "<Leader>n", telescope.extensions.notify.notify },
	{ "n", "<Leader>ts", builtin.treesitter },
	{ "n", "<Leader>lr", builtin.lsp_references },
	{
		"n",
		"<Leader>v",
		function()
			open_buffer_in("vsplit")
		end,
	},
	{
		"n",
		"<Leader>h",
		function()
			open_buffer_in("split")
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
