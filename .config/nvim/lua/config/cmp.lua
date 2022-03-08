local cmp = require("cmp")

cmp.setup({
	mapping = {
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
	},
	sources = {
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "tags" },
		{ name = "treesitter" },
		{ name = "path" },
		{ name = "rg" },
		{ name = "spell" },
		{ name = "cmp_git" },
		{ name = "emoji" },
		{ name = "buffer" },
		{ name = "calc" },
	},
	formatting = {
		format = function(_, vim_item)
			vim_item.dup = { buffer = 1, path = 1, nvim_lsp = 0 }
			return vim_item
		end,
	},
	experimental = { ghost_text = true },
})
