require("ruby_nvim").setup({test_cmd = "rails test"})
vim.api.nvim_set_keymap(
  "n", "<Leader>al", "<Cmd>RubyAlternate<CR>", {noremap = true}
)
