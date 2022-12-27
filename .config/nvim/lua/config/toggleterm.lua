if os.execute("fish --version") == 0 then
	vim.o.shell = "fish"
end

require("toggleterm").setup({ open_mapping = "<C-t>", shade_terminals = false })
