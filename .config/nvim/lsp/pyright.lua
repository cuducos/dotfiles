local M = {
	settings = {
		pyright = {
			disableOrganizeImports = true, -- this is covered by ruff
		},
		python = {
			analysis = {
				autoImportCompletion = true,
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "off",
				useLibraryCodeForTypes = true,
			},
		},
	},
}

vim.keymap.set("n", "<Leader>st", function()
	if vim.bo.filetype ~= "python" then
		return
	end

	local parts = { "import pytest", "pytest.set_trace()" }
	local cmd = table.concat(parts, "; ")

	local cleaned = vim.api.nvim_get_current_line():match("^%s*(.-)%s*$")
	if cleaned == parts[1] or cleaned == parts[2] or cleaned == cmd then
		local bufnr = vim.api.nvim_get_current_buf()
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		for i = #lines, 1, -1 do
			local line = lines[i]:match("^%s*(.-)%s*$")
			if line == parts[1] or line == parts[2] or line == cmd then
				vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, {})
			end
		end
	else
		local _, col = unpack(vim.api.nvim_win_get_cursor(0))
		local current_line = vim.api.nvim_get_current_line()
		local new_line = current_line:sub(1, col) .. " " .. cmd .. current_line:sub(col + 1)
		vim.api.nvim_set_current_line(new_line)
	end
end)

local venv_path = function()
	if vim.fn.isdirectory(".venv") == 1 then
		return vim.fn.getcwd() .. "/.venv"
	end

	if vim.fn.filereadable("pyproject.toml") == 1 then
		local poetry = vim.fn.system("poetry env info -p"):gsub("\n", "")
		if vim.fn.isdirectory(poetry) then
			return poetry
		end
	end
end

local venv = venv_path()

if venv ~= nil then
	local mypy = vim.fn.system(venv .. "/bin/python -m pip show mypy")
	if string.find(mypy, "Name: mypy") ~= nil then
		M.settings.python.analysis.typeCheckingMode = "basic"
	end
	M.settings.python.pythonPath = venv .. "/bin/python"
end

return M
