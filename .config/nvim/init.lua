-- modules
require("plugins")
require("editor")

-- hacked PackerRemove cmd
PackerReinstall = function(name) -- usage example => :lua PackerReinstall "yaml.nvim"
	if package.loaded["packer"] == nil then
		print("Packer not installed or not loaded")
	end

	local utils = require("packer.plugin_utils")
	local suffix = "/" .. name

	local opt, start = utils.list_installed_plugins()
	for _, group in pairs({ opt, start }) do
		if group ~= nil then
			for dir, _ in pairs(group) do
				if dir:sub(-string.len(suffix)) == suffix then
					vim.ui.input({ prompt = "Remove " .. dir .. "? [y/n] " }, function(confirmation)
						if string.lower(confirmation) ~= "y" then
							return
						end
						os.execute("cd " .. dir .. " && git fetch --progress origin && git reset --hard origin")
						vim.cmd(":PackerSync")
					end)
					return
				end
			end
		end
	end
end
vim.cmd("command! -nargs=1 PackerReinstall lua PackerReinstall <f-args>")
