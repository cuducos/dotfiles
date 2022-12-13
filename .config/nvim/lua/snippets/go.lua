local luasnip = require("luasnip")
local path = require("plenary.path")
local util = require("lspconfig.util")

local go_pkg_name = function()
	local cur = vim.fn.expand("%")
	local dir = path:new(cur):parent()

	if util.path.exists(dir .. path.path.sep .. ".git") == "directory" then
		return "main"
	end

	local last_sep = string.find(string.reverse(dir.filename), path.path.sep) - 1
	return string.sub(dir.filename, -last_sep)
end

local snippet = luasnip.snippet
local text = luasnip.text_node
local insert = luasnip.insert_node

return {
	snippet("ife", {
		text({ "if err != nil {", "\treturn " }),
		insert(2),
		text('fmt.Errorf("'),
		insert(1),
		text({ ': %w", err)', "}" }),
	}),
	snippet("ife=", {
		text("if err := "),
		insert(1),
		text({ "; err != nil {", "\treturn " }),
		insert(3),
		text('fmt.Errorf("'),
		insert(2),
		text({ ': %w", err)', "}" }),
	}),
	luasnip.snippet("pkg", { luasnip.text_node({ "package " .. go_pkg_name(), "", "" }) }),
}
