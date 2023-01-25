local luasnip = require("luasnip")

luasnip.setup({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
	store_selection_keys = "<Tab>",
})

luasnip.filetype_extend("ruby", { "rails" })
luasnip.filetype_extend("python", { "django", "djangohtml" })

require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets/" })

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
