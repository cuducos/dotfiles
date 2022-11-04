local luasnip = require("luasnip")
local path = require("plenary.path")
local util = require("lspconfig.util")

luasnip.setup({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
})

local go_pkg_name = function()
	local cur = vim.fn.expand("%")
	local dir = path:new(cur):parent()

	if util.path.exists(dir .. path.path.sep .. ".git") == "directory" then
		return "main"
	end

	local last_sep = string.find(string.reverse(dir.filename), path.path.sep) - 1
	return string.sub(dir.filename, -last_sep)
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
	luasnip.snippet("pkg", { luasnip.text_node({ "package " .. go_pkg_name(), "", "" }) }),
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
