require("editor")
require("plugins")

MasonCleanupLockfiles = function()
	local dir = require("mason-core.path").package_build_prefix()
	for path in io.popen("fd -e lock . " .. dir):lines() do
		local message = "Delete " .. path .. "? [y/n] "
		local response = vim.fn.input(message)
		if response == "y" then
			os.remove(path)
		end
	end
end

vim.cmd("command! -nargs=0 MasonCleanupLockfiles lua MasonCleanupLockfiles()")
