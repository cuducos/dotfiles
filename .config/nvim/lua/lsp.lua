local lsp_config = require("lspconfig")
local mason_lsp_config = require("mason-lspconfig")

M = {}

M.shopify = string.find(vim.loop.cwd(), "Shopify") or os.getenv("SPIN") ~= nil

M.diagnostic_on_notify = function()
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
		{ "n", "<leader>d", require("lsp").diagnostic_on_notify, opts },
		{ "n", "<leader>lsp", require("telescope.builtin").lsp_document_symbols, opts },
		{ "n", "<leader>ptc", require("lsp").toggle_pyright_type_checking, opts },
		{ "n", "<leader>venv", require("lsp").python_virtualenv, opts },
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

M.make_config = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
	return { on_attach = on_attach, capabilities = capabilities }
end

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

if M.shopify then
	extra.servers = {
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

M.to_install = {
	servers = {},
	linters = {},
	formatters = {},
}
for key, _ in pairs(M.to_install) do
	for _, src in pairs({ base, extra }) do
		for _, value in pairs(src[key]) do
			table.insert(M.to_install[key], value)
		end
	end
end

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
			local config = M.make_config()
			if not type_checking then
				config.settings = { python = { analysis = { typeCheckingMode = "off" } } }
			end

			lsp_config[server].setup(config)
			break
		end
	end
end

local function python_virtualenv()
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

M.python_virtualenv = function()
	local name = "pyright"
	local venv = python_virtualenv()
	if venv == nil then
		return
	end

	local clients = vim.lsp.buf_get_clients(0)
	for _, client in pairs(clients) do
		if client.name == name then
			vim.lsp.stop_client(client.id)
			break
		end
	end

	for _, server in pairs(mason_lsp_config.get_installed_servers()) do
		if server.name == name then
			local config = M.make_config()
			config.settings = { python = { venvPath = venv } }
			lsp_config[server].setup(config)
			break
		end
	end
end

return M
