-- formatter modules
local function prettier()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
    stdin = true,
  }
end

require("formatter").setup(
  {
    logging = false,
    filetype = {
      lua = {
        function()
          return {
            exe = "lua-format",
            args = {"-c " .. vim.fn.expand("~/.config/nvim/lua/.lua-format")},
            stdin = true,
          }
        end,
      },
      python = {
        function()
          return {exe = "black", args = {"-q", "-"}, stdin = true}
        end,
      },
      javascript = {prettier},
      javascriptreact = {prettier},
      markdown = {prettier},
      json = {
        function()
          return {
            exe = "prettier",
            args = {
              "--stdin-filepath",
              vim.api.nvim_buf_get_name(0),
              "--parser",
              "json",
            },
            stdin = true,
          }
        end,
      },
      go = {
        function()
          return {exe = "gofmt", stdin = true}
        end,
        function()
          return {exe = "goimports", stdin = true}
        end,
      },
      ruby = {
        function()
          return {
            exe = "rubocop",
            stdin = true,
            args = {
              "--stdin",
              vim.api.nvim_buf_get_name(0),
              "--stderr",
              "--auto-correct-all",
            },
          }
        end,
      },
      rust = {
        function()
          return {exe = "rustfmt", args = {"--emit=stdout"}, stdin = true}
        end,
      },
    },
  }
)

-- vim.api.nvim_exec(
--   [[
-- augroup FormatAu
--     autocmd!
--     autocmd BufWritePost *.go,*.lua,*.elm,*.rs,*.md FormatWrite
-- augroup END
-- ]]
-- )

vim.api.nvim_set_keymap("n", "<leader>af", "<Cmd>Format<CR>", {noremap = true})
