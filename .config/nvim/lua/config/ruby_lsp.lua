local configs = require("lspconfig.configs")
local lsp = require("lsp")
local mason = require("config.mason")

if not configs.ruby_lsp then
	configs.ruby_lsp = {
		default_config = {
			cmd = { "bundle", "exec", "ruby-lsp" },
			filetypes = { "ruby" },
			root_dir = require("lspconfig.util").root_pattern("Gemfile", ".git"),
			init_options = {
				enabledFeatures = {
					"documentHighlights",
					"documentSymbols",
					"foldingRanges",
					"selectionRanges",
					"semanticHighlighting",
					"formatting",
					"codeActions",
				},
			},
			settings = {},
		},
		commands = {
			FormatRuby = {
				function()
					vim.lsp.buf.format({
						name = "ruby_lsp",
						async = true,
					})
				end,
				description = "Format using ruby-lsp",
			},
		},
		on_attach = function(client, bufnr)
			lsp.on_attach(client, bufnr)

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePre", "CursorHold" }, {
				buffer = bufnr,

				callback = function()
					local params = vim.lsp.util.make_text_document_params(bufnr)

					client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
						if err then
							return
						end

						vim.lsp.diagnostic.on_publish_diagnostics(
							nil,
							vim.tbl_extend("keep", params, { diagnostics = result.items }),
							{ bufnr = bufnr, client_id = client.id }
						)
					end)
				end,
			})
		end,
	}
	if lsp.shopify then
		require("lspconfig").ruby_lsp.setup(lsp.make_config())
	end
end
