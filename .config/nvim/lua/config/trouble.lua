require("trouble").setup({})
vim.api.nvim_set_keymap(
  "n", "<Leader>t", "<Cmd>Trouble<CR>", {noremap = true}
)
