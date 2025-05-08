local blink = require("blink.cmp")

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

local mappings = {

	{ "n", "gd", vim.lsp.buf.definition, opts },
	{ "n", "gD", vim.lsp.buf.type_definition, opts },
	{ "n", "gr", vim.lsp.buf.rename, opts },
	{
		"n",
		"K",
		function()
			vim.lsp.buf.signature_help({ border = "rounded" })
		end,
		opts,
	},
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
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr = 0 })
		end,
	},
}

M.make_config = function()
	return {
		capabilities = blink.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
		on_attach = function(client, _)
			local opts = { silent = true, noremap = true, buffer = true }
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
		end,
	}
end

M.to_install = {
	servers = {
		"cssls",
		"dockerls",
		"elmls",
		"gopls",
		"graphql",
		"jsonls",
		"lua_ls",
		"pyright",
		"ruff",
		"rust_analyzer",
		"sqlls",
		"ts_ls",
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

return M
