local installer = require("nvim-lsp-installer")
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
		{ "n", "gS", require("telescope.builtin").lsp_document_symbols, opts },
	}
	for _, mapping in pairs(mappings) do
		vim.keymap.set(unpack(mapping))
	end

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		local lsp_document_highlight = vim.api.nvim_create_augroup("LspDocumentHighlight", {})
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

	local config = {
		on_attach = on_attach,
		capabilities = capabilities,
		handlers = {
			["textDocument/publishDiagnostics"] = vim.lsp.with(
				vim.lsp.diagnostic.on_publish_diagnostics,
				{ virtual_text = false }
			),
		},
	}

	if server.name == "sumneko_lua" then
		config.settings = { Lua = { diagnostics = { globals = { "vim" } } } }
	end

	return config
end

local function setup_servers()
	local required_servers = {
		"gopls",
		"jsonls",
		"sumneko_lua",
		"yamlls",
	}
	local extra_servers = {}
	if string.find(vim.loop.cwd(), "Shopify") then
		extra_servers = {
			"solargraph",
			"tsserver",
		}
	else
		extra_servers = {
			"cssls",
			"dockerls",
			"elmls",
			"pyright",
			"rust_analyzer",
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

	for _, server in pairs(required_servers) do
		if not is_installed(server) then
			installer.install(server)
		end
	end

	for _, server in pairs(servers.get_installed_servers()) do
		local config = make_config(server)
		server:setup(config)
	end
end

setup_servers()
