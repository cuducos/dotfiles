local yaml_nvim = require("yaml_nvim")
yaml_nvim.setup({ ft = { "yaml" } })
vim.keymap.set("n", "<Leader>y", yaml_nvim.fzf_lua)
