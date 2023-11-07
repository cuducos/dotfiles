require("yaml_nvim").setup({ ft = { "yaml" } })
vim.keymap.set("n", "<Leader>y", "<Cmd>YAMLTelescope<CR>", {})
