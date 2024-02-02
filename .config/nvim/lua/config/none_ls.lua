local none_ls = require("null-ls")

none_ls.setup({
	sources = {
		none_ls.builtins.code_actions.eslint,
		none_ls.builtins.code_actions.gitsigns,
		none_ls.builtins.code_actions.gomodifytags,
		none_ls.builtins.code_actions.refactoring,
		none_ls.builtins.code_actions.ts_node_action,
		none_ls.builtins.completion.luasnip,
		none_ls.builtins.completion.spell,
		none_ls.builtins.completion.tags,
		none_ls.builtins.diagnostics.eslint,
		none_ls.builtins.diagnostics.fish,
		none_ls.builtins.diagnostics.staticcheck,
		none_ls.builtins.diagnostics.tsc,
		none_ls.builtins.diagnostics.typos,
		none_ls.builtins.formatting.elm_format,
		none_ls.builtins.formatting.eslint,
		none_ls.builtins.formatting.fish_indent,
		none_ls.builtins.formatting.gofmt,
		none_ls.builtins.formatting.goimports,
		none_ls.builtins.formatting.ruff,
		none_ls.builtins.formatting.ruff_format,
		none_ls.builtins.formatting.rustfmt,
		none_ls.builtins.formatting.stylua,
	},
})

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
