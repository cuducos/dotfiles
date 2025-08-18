local M = {
	settings = {
		basedpyright = {
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
