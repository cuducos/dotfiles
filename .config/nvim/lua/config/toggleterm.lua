if vim.fn.executable("fish") == 1 then
	vim.o.shell = "fish"
end

require("toggleterm").setup({ open_mapping = "<C-t>", shade_terminals = false })
