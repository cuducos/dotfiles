local dap = require("dap")
local mappings = {
	{ "n", "<leader>dc", dap.continue },
	{ "n", "<leader>db", dap.toggle_breakpoint },
	{ "n", "<leader>dr", dap.repl.open },
	{ "n", "<leader>di", dap.step_into },
	{ "n", "<leader>do", dap.step_over },
}
for _, mapping in pairs(mappings) do
	vim.keymap.set(unpack(mapping))
end
