local lsp = require("lsp")
local lsp_config = require("lspconfig")
local mason = require("mason")
local mason_lsp_config = require("mason-lspconfig")

local function setup_servers()
	mason.setup()
	mason_lsp_config.setup({ ensure_installed = lsp.to_install.servers })
	mason_lsp_config.setup_handlers({
		function(server)
			local config = lsp.make_config()
			lsp_config[server].setup(config)
		end,
		["rust_analyzer"] = function()
			local config = lsp.make_config()
			config.settings = {
				["rust-analyzer"] = {
					checkOnSave = { command = "clippy" },
				},
			}
			lsp_config.rust_analyzer.setup(config)
		end,
		["sumneko_lua"] = function()
			local config = lsp.make_config()
			config.settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
				},
			}
			lsp_config.sumneko_lua.setup(config)
		end,
	})
	vim.diagnostic.config({ virtual_text = false })
end

local function setup_linters_and_formatters()
	local installed = require("mason-registry").get_installed_package_names()
	local function is_installed(pkg)
		for _, name in pairs(installed) do
			if pkg == name then
				return true
			end
		end
		return false
	end

	local args = {}
	for key, tbl in pairs(lsp.to_install) do
		if key ~= "servers" then
			for _, arg in pairs(tbl) do
				if not is_installed(arg) then
					table.insert(args, arg)
				end
			end
		end
	end

	if #args > 0 then
		require("mason.api.command").MasonInstall(args)
	end
end

setup_servers()
setup_linters_and_formatters()
