local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

cmp.setup({
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<Esc>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	},
	sources = {
		{ name = "copilot" },
		{ name = "nvim_lsp_document_symbol" },
		{ name = "luasnip" },
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "treesitter" },
		{ name = "path" },
		{ name = "emoji" },
	},
	formatting = {
		format = lspkind.cmp_format({
			before = function(entry, item)
				if entry.source.name == "copilot" then
					item.kind = "Copilot "
					item.kind_hl_group = "CmpItemKindCopilot"
				end
				item.dup = { buffer = 1, path = 1, nvim_lsp = 0 }
				return item
			end,
		}),
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})
