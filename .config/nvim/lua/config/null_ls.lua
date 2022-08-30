local null_ls = require("null-ls")

local is_ruby = function(path)
	return string.match(path, ".rb$") == ".rb"
end

local is_shopify = function(path)
	return string.find(path, "Shopify") ~= nil
end

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.elm_format,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.rubocop,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.fish,
		null_ls.builtins.diagnostics.rubocop,
		null_ls.builtins.diagnostics.staticcheck,
		null_ls.builtins.diagnostics.tsc,
	},
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("FormatOnSave", {}),
	pattern = { "*.elm", "*.go", "*.rs", "*.rb" },
	callback = function()
		local path = vim.api.nvim_buf_get_name(0)
		if is_ruby(path) and not is_shopify(path) then
			return
		end

		vim.lsp.buf.formatting_seq_sync()
	end,
})

local mappings = {
	{ "n", "<leader>af", vim.lsp.buf.formatting_seq_sync },
	{ "n", "<leader>ca", vim.lsp.buf.code_action },
}
for _, mapping in pairs(mappings) do
	vim.keymap.set(unpack(mapping))
end
