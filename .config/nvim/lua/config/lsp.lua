local installer = require("nvim-lsp-installer")
local platform = require("nvim-lsp-installer.core.platform")
local servers = require("nvim-lsp-installer.servers")

local diagnostic_on_notify = function()
	local opts = {
		format = function(item)
			local severity = vim.log.levels.INFO
			if item.severity == vim.diagnostic.severity.ERROR then
				severity = vim.log.levels.ERROR
			end
			if item.severity == vim.diagnostic.severity.WARN then
				severity = vim.log.levels.WARN
			end

			local message = string.format("%d:%d %s", item.lnum, item.col, item.message)
			vim.notify(message, severity, { title = item.source })
			return item.message
		end,
	}

	local bufnr, _ = vim.diagnostic.open_float(opts)
	if bufnr ~= nil then
		vim.cmd("bw " .. bufnr)
	end
end

local function on_attach(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.lsp.omnifunc")

	local opts = { silent = true, noremap = true, buffer = true }
	local mappings = {
		{ "n", "gd", vim.lsp.buf.definition, opts },
		{ "n", "gr", vim.lsp.buf.rename, opts },
		{ "n", "gs", vim.lsp.buf.hover, opts },
		{ "n", "[e", vim.lsp.diagnostic.goto_next, opts },
		{ "n", "]e", vim.lsp.diagnostic.goto_prev, opts },
		{ "n", "<leader>d", diagnostic_on_notify, opts },
		{ "n", "<leader>lsp", require("telescope.builtin").lsp_document_symbols, opts },
		{ "n", "<leader>ptc", require("config.lsp").toggle_pyright_type_checking, opts },
	}
	for _, mapping in pairs(mappings) do
		vim.keymap.set(unpack(mapping))
	end

	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_create_augroup("LspDocumentHighlight", {})
		vim.api.nvim_create_autocmd("CursorHold", {
			pattern = "<buffer>",
			callback = function()
				vim.lsp.buf.document_highlight()
			end,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			pattern = "<buffer>",
			callback = function()
				vim.lsp.buf.clear_references()
			end,
		})
	end
end

local function make_config(server)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

	local config = { on_attach = on_attach, capabilities = capabilities }
	if server.name == "sumneko_lua" then
		config.settings = { Lua = { runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } } } }
	elseif server.name == "rust_analyzer" then
		config.settings = { ["rust-analyzer"] = { checkOnSave = { command = "clippy" } } }
	end

	return config
end

local function setup_servers()
	local required_servers = {
		"bashls",
		"cssls",
		"gopls",
		"jsonls",
		"pyright",
		"rust_analyzer",
		"sumneko_lua",
		"yamlls",
	}
	local extra_servers = {}
	if string.find(vim.loop.cwd(), "Shopify") or os.getenv("SPIN") ~= nil then
		extra_servers = {
			"solargraph",
			"sorbet",
			"tsserver",
		}
	else
		extra_servers = {
			"dockerls",
			"elmls",
		}
	end
	for _, server in pairs(extra_servers) do
		table.insert(required_servers, server)
	end

	local installed = servers.get_installed_servers()
	local is_installed = function(server_name)
		for _, installed_server in pairs(installed) do
			if server_name == installed_server.name then
				return true
			end
		end

		return false
	end

	local install = function(pending_servers)
		if next(pending_servers) == nil then
			return
		end

		if platform.is_headless then
			installer.install_sync(pending_servers)
		else
			for _, server in pairs(pending_servers) do
				installer.install(server)
			end
		end
	end

	local pending = {}
	for _, server in pairs(required_servers) do
		if not is_installed(server) then
			table.insert(pending, server)
		end
	end
	install(pending)

	for _, server in pairs(servers.get_installed_servers()) do
		local config = make_config(server)
		server:setup(config)
	end

	vim.diagnostic.config({ virtual_text = false })
end

setup_servers()

M = {}

M.toggle_pyright_type_checking = function()
	local name = "pyright"
	local type_checking = true

	local clients = vim.lsp.buf_get_clients(0)
	for _, client in pairs(clients) do
		if client.name == name then
			type_checking = client.config.settings.python.analysis.typeCheckingMode == "off"
			vim.lsp.stop_client(client.id)
			break
		end
	end

	for _, server in pairs(servers.get_installed_servers()) do
		if server.name == name then
			local config = make_config(server)
			if not type_checking then
				config.settings = { python = { analysis = { typeCheckingMode = "off" } } }
			end

			server:setup(config)
			break
		end
	end
end

return M
