require("yaml_nvim").init()
local mappings = {
  {"n", "<Leader>y", "<Cmd>YAMLTelescope<CR>"},
  {"n", "<Leader>yy", "<Cmd>YAMLView<CR>"},
  {"n", "<Leader>Y", "<Cmd>YAMLYank<CR>"},
  {"n", "<Leader>Yk", "<Cmd>YAMLYankKey<CR>"},
}
for _, args in pairs(mappings) do
  vim.api.nvim_set_keymap(unpack(args), {noremap = true, silent = true})
end
