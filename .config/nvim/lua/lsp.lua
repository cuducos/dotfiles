local blink = require("blink.cmp")

M = {}

local is_lua = function(path)
	return string.match(path, ".lua$") == ".lua"
end

local is_mine = function()
	local origin = vim.fn.system("git remote show origin -n")
	return string.find(origin, "cuducos") ~= nil
end

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("FormatOnSave", {}),
	pattern = { "*.elm", "*.fish", "*.go", "*.lua", "*.py", "*.rb", "*.rs", "*.ts", "*.tsx" },
	callback = function()
		local path = vim.api.nvim_buf_get_name(0)
		if is_lua(path) and not is_mine() then
			return
		end

		vim.lsp.buf.format({ async = false })
	end,
})

local mappings = {
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
			for _, mapping in pairs(mappings) do
				vim.keymap.set(unpack(mapping))
			end
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
			vim.lsp.inlay_hint.enable()
		end,
	}
end

M.to_install = {
	servers = {
		"dockerls",
		"elmls",
		"golangci_lint_ls",
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
