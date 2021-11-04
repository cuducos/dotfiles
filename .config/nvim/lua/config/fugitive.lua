local opts = {noremap = true, silent = true}
local mappings = {
  {"n", "<Leader>gs", "<Cmd>G<CR>", opts},
  {"n", "<Leader>gh", "<Cmd>diffget //2<CR>", opts},
  {"n", "<Leader>gf", "<Cmd>diffget //3<CR>", opts},
}
for _, args in pairs(mappings) do
  vim.api.nvim_set_keymap(unpack(args))
end
