require("hop").setup({keys = "etovxqpdygfblzhckisuran"})
vim.api
  .nvim_set_keymap("n", ";", "<Cmd>lua require('hop').hint_char2()<CR>", {})
