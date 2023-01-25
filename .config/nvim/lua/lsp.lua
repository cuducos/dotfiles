M = {}

M.shopify = string.find(vim.loop.cwd(), "Shopify") or os.getenv("SPIN") ~= nil

local has_float = function()
	local wins = vim.api.nvim_list_wins()
	for _, win in pairs(wins) do
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			return true
		end
	end
	return false
end

local function on_attach(client, bufnr)
	local opts = { silent = true, noremap = true, buffer = true }
	local mappings = {
		{ "n", "gd", vim.lsp.buf.definition, opts },
		{ "n", "gD", vim.lsp.buf.type_definition, opts },
		{ "n", "gr", vim.lsp.buf.rename, opts },
		{ "n", "gs", vim.lsp.buf.hover, opts },
		{ "n", "=", vim.diagnostic.goto_next, opts },
		{ "n", "-", vim.diagnostic.goto_prev, opts },
		{ "n", "<leader>s", require("telescope.builtin").lsp_document_symbols, opts },
		{ "n", "<leader>S", require("telescope.builtin").lsp_workspace_symbols, opts },
		{ "n", "<leader>r", require("telescope.builtin").lsp_references, opts },
		{ "n", "<Leader>a", vim.lsp.buf.format },
		{ "n", "<Leader><Leader>", vim.lsp.buf.code_action },
	}
	for _, mapping in pairs(mappings) do
		vim.keymap.set(unpack(mapping))
	end

	local diagnostic = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			if has_float() then
				return
			end

			vim.diagnostic.open_float(nil, { focus = false })
		end,
		group = diagnostic,
	})

	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	if client.server_capabilities.document_highlight then
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
	local border = {
		{ "╭", "FloatBorder" },
		{ "─", "FloatBorder" },
		{ "╮", "FloatBorder" },
		{ "│", "FloatBorder" },
		{ "╯", "FloatBorder" },
		{ "─", "FloatBorder" },
		{ "╰", "FloatBorder" },
		{ "│", "FloatBorder" },
	}
	local handlers = {
		["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
		["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
	}
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	return { on_attach = on_attach, capabilities = capabilities, handlers = handlers }
end

local base = {
	servers = {
		"cssls",
		"sumneko_lua",
		"yamlls",
	},
	linters = {
		"markdownlint",
		"vale",
	},
	formatters = {
		"sql-formatter",
		"stylua",
		"rustfmt",
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

M.make_pyright_config = function()
	local config = M.make_config()
	config.settings = {
		pyright = { autoImportCompletion = true },
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "off",
			},
		},
	}

	local function venv_path()
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
	if venv == nil then
		return config
	end

	local packages = vim.fn.system(venv .. "/bin/python -m pip --list")
	if string.find(packages, "mypy") ~= nil then
		config.settings.python.analysis.typeCheckingMode = "basic"
	end

	config.settings.python.pythonPath = venv .. "/bin/python"
	return config
end

return M
