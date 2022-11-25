vim.g["test#strategy"] = "make"

local mappings = {
	{ "n", "t", ":TestNearest<CR>" },
	{ "n", "T", ":TestSuite<CR>" },
}
for _, val in pairs(mappings) do
	vim.keymap.set(unpack(val))
end
