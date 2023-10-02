local none_ls = require("null-ls")

none_ls.setup({
	sources = {
		none_ls.builtins.formatting.black,
		none_ls.builtins.formatting.elm_format,
		none_ls.builtins.formatting.gofmt,
		none_ls.builtins.formatting.goimports,
		none_ls.builtins.formatting.prettier,
		none_ls.builtins.formatting.rubocop,
		none_ls.builtins.formatting.rustfmt,
		none_ls.builtins.formatting.stylua,
		none_ls.builtins.code_actions.gitsigns,
		none_ls.builtins.diagnostics.eslint,
		none_ls.builtins.diagnostics.fish,
		none_ls.builtins.diagnostics.rubocop,
		none_ls.builtins.diagnostics.staticcheck,
		none_ls.builtins.diagnostics.tsc,
	},
})

local is_ruby = function(path)
	return string.match(path, ".rb$") == ".rb"
end

local is_shopify = function(path)
	return string.find(path, "Shopify") ~= nil
end

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("FormatOnSave", {}),
	pattern = { "*.elm", "*.go", "*.py", "*.rb", "*.rs", "*.ts", "*.tsx" },
	callback = function()
		local path = vim.api.nvim_buf_get_name(0)
		if is_ruby(path) and not is_shopify(path) then
			return
		end

		vim.lsp.buf.format()
	end,
})
