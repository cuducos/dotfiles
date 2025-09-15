require("editor.config")
require("editor.keymaps")
require("editor.autocmds")

-- TODO is there a Lua API for those?
vim.cmd([[
    cnoreabbrev W w
    cnoreabbrev W! w!
    cnoreabbrev Q q
    cnoreabbrev Q! q!
    cnoreabbrev Qa qa
    cnoreabbrev Qa! qa!
    cnoreabbrev Wq wq
    cnoreabbrev Wa wa
    cnoreabbrev WQ wq
    cnoreabbrev Wqa wqa

    iabbrev /t <ESC>oTODO<ESC><ESC><ESC>VgckJ$a
    iabbrev /r <ESC>oTODO: remove<ESC><ESC><ESC>VgckJ$a
    ]])
