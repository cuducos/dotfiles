local lsp = require("lsp")
local lsp_config = require("lspconfig")

vim.api.nvim_create_user_command("MasonUpgrade", function()
	local registry = require("mason-registry")
	registry.refresh()
	registry.update()
	local packages = registry.get_all_packages()
	for _, pkg in ipairs(packages) do
		if pkg:is_installed() then
			pkg:install()
		end
	end
	vim.cmd("doautocmd User MasonUpgradeComplete")
end, { force = true })

local function setup_servers()
	require("mason").setup()

	local mason_lsp_config = require("mason-lspconfig")
	mason_lsp_config.setup({ ensure_installed = lsp.to_install.servers })
	mason_lsp_config.setup_handlers({
		function(server)
			local config = lsp.make_config()
			lsp_config[server].setup(config)
		end,
		["rust_analyzer"] = function() end, -- done in rustaceanvim
		["lua_ls"] = function()
			local config = lsp.make_config()
			config.settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
					hint = { enable = true },
				},
			}
			lsp_config.lua_ls.setup(config)
		end,
		["pyright"] = function()
			local config = lsp.make_pyright_config()
			lsp_config.pyright.setup(config)
		end,
		["yamlls"] = function()
			local config = lsp.make_config()
			config.settings = { yaml = { keyOrdering = false } }
			lsp_config.yamlls.setup(config)
		end,
		["gopls"] = function()
			local config = lsp.make_config()
			config.settings = {
				gopls = {
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			}
			lsp_config.gopls.setup(config)
		end,
		["ts_ls"] = function()
			local config = lsp.make_config()
			local inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			}
			config.settings = {
				javascript = { inlayHints = inlayHints },
				typescript = { inlayHints = inlayHints },
			}
			lsp_config.ts_ls.setup(config)
		end,
	})
	vim.diagnostic.config({
		float = { border = "rounded" },
		virtual_text = false,
	})
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
