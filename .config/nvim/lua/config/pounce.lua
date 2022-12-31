require("pounce").setup({ accept_best_key = "<Tab>" })
vim.keymap.set("n", "<Tab>", "<Cmd>Pounce<CR>")
vim.keymap.set("n", "<S-Tab>", "<Cmd>PounceRepeat<CR>")
