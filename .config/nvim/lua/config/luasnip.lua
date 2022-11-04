local luasnip = require("luasnip")

luasnip.setup({})
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
})
