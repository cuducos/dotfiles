local lsp = require("lsp")

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
	mason_lsp_config.setup({
		ensure_installed = lsp.to_install.servers,
		automatic_enable = {
			exclude = { "rust_analyzer" }, -- done in rustaceanvim
		},
	})
	vim.lsp.config("*", lsp.make_config())
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
