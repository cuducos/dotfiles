vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_filetypes = { ["dap-repl"] = false }

vim.keymap.set("i", "<C-c>", 'copilot#Accept("<CR>")', { expr = true })
