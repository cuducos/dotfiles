local cmp = require("cmp")

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

cmp.setup(
  {
    mapping = {
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm(
        {behavior = cmp.ConfirmBehavior.Insert, select = true}
      ),
      ["<Tab>"] = function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(
            vim.api.nvim_replace_termcodes("<C-n>", true, true, true), "n"
          )
        elseif check_back_space() then
          vim.fn.feedkeys(
            vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n"
          )
        else
          fallback()
        end
      end,
    },
    sources = {
      {name = "buffer"},
      {name = "calc"},
      {name = "emoji"},
      {name = "look"},
      {name = "luasnip"},
      {name = "nvim_lsp"},
      {name = "nvim_lua"},
      {name = "path"},
      {name = "spell"},
      {name = "tags"},
      {name = "treesitter"},
      {name = "ultisnips"},
      {name = "vsnip"},
    },
  }
)
