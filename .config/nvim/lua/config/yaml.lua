local opts = {noremap = true, silent = true}
local mappings = {
  {"n", "<Leader>y", "<Cmd>YAMLTelescope<CR>", opts},
  {"n", "<Leader>yy", "<Cmd>YAMLView<CR>", opts},
  {"n", "<Leader>Y", "<Cmd>YAMLYank<CR>", opts},
  {"n", "<Leader>Yk", "<Cmd>YAMLYankKey<CR>", opts},
}
for _, args in pairs(mappings) do
  vim.api.nvim_set_keymap(unpack(args))
end
