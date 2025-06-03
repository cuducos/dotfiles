local dap = require("dap")

local python_path = function()
	for _, dir in ipairs({ ".venv", "venv" }) do
		if vim.fn.isdirectory(dir) == 1 then
			local bin = vim.fn.getcwd() .. "/" .. dir .. "/bin/"
			local python = bin .. "python"
			if not vim.uv.fs_stat(bin .. "debugpy") then
				vim.fn.system(python .. "-m pip install debugpy")
			end
			return python
		end
	end
	return vim.fn.system("which python")
end

local python = python_path()

dap.adapters.python = function(cb, config)
	if config.request == "attach" then
		local port = (config.connect or config).port
		local host = (config.connect or config).host or "127.0.0.1"
		cb({
			type = "server",
			port = assert(port, "`connect.port` is required for a python `attach` configuration"),
			host = host,
			options = {
				source_filetype = "python",
			},
		})
	else
		cb({
			type = "executable",
			command = python,
			args = { "-m", "debugpy.adapter" },
			options = {
				source_filetype = "python",
			},
		})
	end
end
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		pythonPath = python_path,
	},
}

require("dapui").setup()

vim.keymap.set("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<leader>dc", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<leader>dui", function()
	require("dapui").toggle()
end)
vim.keymap.set("n", "<leader>do", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<leader>di", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<leader>dr", function()
	require("dap").repl.open()
end)
