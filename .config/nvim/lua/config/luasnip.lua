local luasnip = require("luasnip")
local path = require("plenary.path")

local go_pkg_name = function()
	local cwd = vim.fn.getcwd()
	local pkg = path:new(cwd)
	if cwd ~= require("lspconfig.util").root_pattern(".git") then
		return "main"
	end
	return pkg.filename
end

luasnip.add_snippets("go", {
	luasnip.snippet("ifer", {
		luasnip.text_node({ "if err != nil {", "\treturn " }),
		luasnip.insert_node(2),
		luasnip.text_node('fmt.Errorf("'),
		luasnip.insert_node(1),
		luasnip.text_node({ ': %w", err)', "}" }),
	}),
	luasnip.snippet("ifer=", {
		luasnip.text_node("if err := "),
		luasnip.insert_node(1),
		luasnip.text_node({ "; err != nil {", "\treturn " }),
		luasnip.insert_node(3),
		luasnip.text_node('fmt.Errorf("'),
		luasnip.insert_node(2),
		luasnip.text_node({ ': %w", err)', "}" }),
	}),
	luasnip.snippet("pkg", { luasnip.text_node("package " .. go_pkg_name()) }),
})

vim.api.nvim_create_autocmd("BufNewFile", {
	group = vim.api.nvim_create_augroup("GoAutoAddPkgLine", {}),
	pattern = "*.go",
	callback = function()
		for _, snippet in pairs(luasnip.get_snippets("go")) do
			if snippet.name == "pkg" then
				luasnip.snip_expand(snippet, {})
				return
			end
		end
	end,
})
