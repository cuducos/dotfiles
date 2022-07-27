local lsp_config = require("lspconfig")
local mason = require("mason")
local mason_lsp_config = require("mason-lspconfig")

local shopify = string.find(vim.loop.cwd(), "Shopify") or os.getenv("SPIN") ~= nil

local base = {
	servers = {
		"cssls",
		"sumneko_lua",
		"yamlls",
	},
	linters = {
		"markdownlint",
		"shellcheck",
		"vale",
	},
	formatters = {
		"sql-formatter",
		"stylua",
	},
}

local extra = {
	servers = {},
	linters = {},
	formatters = {},
}

if shopify then
	extra.servers = {
		"solargraph",
		"sorbet",
		"tsserver",
	}
else
	extra = {
		servers = {
			"bashls",
			"dockerls",
			"elmls",
			"gopls",
			"jsonls",
			"pyright",
			"rust_analyzer",
		},
		linters = {
			"flake8",
			"staticcheck",
		},
		formatters = {
			"elm-format",
			"isort",
			"prettier",
		},
	}
end

local to_install = {
	servers = {},
	linters = {},
	formatters = {},
}
for key, value in pairs(to_install) do
	for _, src in pairs({ base, extra }) do
		for _, value in pairs(src[key]) do
			table.insert(to_install[key], value)
		end
	end
end

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

local function make_config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
	return { on_attach = on_attach, capabilities = capabilities }
end

local function setup_servers()
	mason.setup()
	mason_lsp_config.setup({ ensure_installed = to_install.servers })
	mason_lsp_config.setup_handlers({
		function(server)
			local config = make_config()
			lsp_config[server].setup(config)
		end,
		["rust_analyzer"] = function()
			local config = make_config()
			config.settings = {
				["rust-analyzer"] = {
					checkOnSave = { command = "clippy" },
				},
			}
			lsp_config.rust_analyzer.setup(config)
		end,
		["sumneko_lua"] = function()
			local config = make_config()
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
	local args = {}
	for key, tbl in pairs(to_install) do
		if key ~= "servers" then
			for _, arg in pairs(tbl) do
				table.insert(args, arg)
			end
		end
	end

	require("mason.api.command").MasonInstall(args)
end

setup_servers()
setup_linters_and_formatters()

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

	for _, server in pairs(mason_lsp_config.get_installed_servers()) do
		if server.name == name then
			local config = make_config(server)
			if not type_checking then
				config.settings = { python = { analysis = { typeCheckingMode = "off" } } }
			end

			lsp_config[server].setup(config)
			break
		end
	end
end

return M
