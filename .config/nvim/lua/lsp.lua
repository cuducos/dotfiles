M = {}

local has_float = function()
	local wins = vim.api.nvim_list_wins()
	for _, win in pairs(wins) do
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			return true
		end
	end
	return false
end

M.on_attach = function(client, _)
	local opts = { silent = true, noremap = true, buffer = true }
	local mappings = {
		{ "n", "gd", vim.lsp.buf.definition, opts },
		{ "n", "gD", vim.lsp.buf.type_definition, opts },
		{ "n", "gr", vim.lsp.buf.rename, opts },
		{ "n", "<Leader>s", require("telescope.builtin").lsp_document_symbols, opts },
		{ "n", "<Leader>S", require("telescope.builtin").lsp_workspace_symbols, opts },
		{ "n", "<Leader>r", require("telescope.builtin").lsp_references, opts },
		{
			"n",
			"<Leader>a",
			function()
				if vim.bo.filetype == "python" then
					vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll.ruff" } } })
				end
				vim.lsp.buf.format({ async = true })
			end,
		},
		{ "n", "<Leader><Leader>", vim.lsp.buf.code_action },
		{
			"n",
			"<Leader>ih",
			function()
				vim.lsp.buf.inlay_hint(0, nil)
			end,
		},
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
	vim.lsp.inlay_hint.enable()
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
	return { on_attach = M.on_attach, capabilities = capabilities, handlers = handlers }
end

M.to_install = {
	servers = {
		"cssls",
		"dockerls",
		"elmls",
		"gopls",
		"jsonls",
		"lua_ls",
		"pyright",
		"ruff_lsp",
		"rust_analyzer",
		"sqlls",
		"tsserver",
		"yamlls",
	},
	linters = {
		"eslint-lsp",
		"markdownlint",
		"staticcheck",
		"typos-lsp",
		"yamllint",
	},
	formatters = {
		"elm-format",
		"prettierd",
		"stylua",
	},
}

M.make_pyright_config = function()
	local config = M.make_config()
	config.settings = {
		pyright = {
			disableOrganizeImports = true, -- this is covered by ruff-lsp
		},
		python = {
			analysis = {
				autoImportCompletion = true,
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "off",
				useLibraryCodeForTypes = true,
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

	local mypy = vim.fn.system(venv .. "/bin/python -m pip show mypy")
	if string.find(mypy, "Name: mypy") ~= nil then
		config.settings.python.analysis.typeCheckingMode = "basic"
	end

	config.settings.python.pythonPath = venv .. "/bin/python"
	return config
end

return M
