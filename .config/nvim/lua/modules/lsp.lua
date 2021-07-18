-- lsp configs
local aerial = require("aerial")
local nvim_lsp = require("lspconfig")
local saga = require("lspsaga")
local lspinstall = require("lspinstall")
saga.init_lsp_saga(
  {error_sign = "✗", warn_sign = "⚠", code_action_prompt = {enable = false}}
)

-- configure completion
require("compe").setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    spell = true,
    vsnip = true,
  },
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

-- Use (shift) tab to:
--- move to prev/next item in completion mopts},
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

local menuone_opts = {expr = true, silent = true, noremap = true}
local menuone_mappings = {
  {"i", "<C-Space>", "compe#complete()", menuone_opts},
  {"i", "<C-e>", "compe#close('<C-e>')", menuone_opts},
  {"i", "<CR>", "compe#confirm('<CR>')", menuone_opts},
  {"i", "<S-Tab>", "v:lua.s_tab_complete()", menuone_opts},
  {"i", "<Tab>", "v:lua.tab_complete()", menuone_opts},
  {"s", "<S-Tab>", "v:lua.s_tab_complete()", menuone_opts},
  {"s", "<Tab>", "v:lua.tab_complete()", menuone_opts},
}
for _, val in pairs(menuone_mappings) do
  vim.api.nvim_set_keymap(unpack(val))
end

local function on_attach(client, bufnr)
  aerial.on_attach(client)

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.lsp.omnifunc")

  local opts = {silent = true, noremap = true}
  local mappings = {
    {"n", "gd", [[<Cmd>lua vim.lsp.buf.definition()<CR>]], opts},
    {
      "n",
      "gD",
      [[<Cmd>lua require('lspsaga.provider').preview_definition()<CR>]],
      opts,
    },
    {"n", "gr", [[<Cmd>lua require('lspsaga.rename').rename()<CR>]], opts},
    {
      "n",
      "gR",
      [[<Cmd>lua require('telescope.builtin').lsp_references({ path_display = 'shorten' })<CR>]],
      {noremap = true, silent = true},
    },
    {
      "i",
      "gs",
      [[<Cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]],
      opts,
    },
    {
      "n",
      "gS",
      [[<Cmd>lua require('lspsaga.hover').render_hover_doc()<CR>]],
      opts,
    },
    {
      "n",
      "[e",
      [[<Cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>]],
      opts,
    },
    {
      "n",
      "]e",
      [[<Cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev() <CR>]],
      opts,
    },
    {"n", "<Leader>a", [[<Cmd>AerialToggle<CR>]], opts},
    {"n", "<Leader>A", [[<Cmd>AerialToggle!<CR>]], opts},

  }

  for _, map in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(bufnr, unpack(map))
  end

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_buf_set_keymap(
      bufnr, "n", "<leader>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts
    )
  elseif client.resolved_capabilities.document_range_formatting then
    vim.api.nvim_buf_set_keymap(
      bufnr, "n", "<leader>F", "<cmd>lua vim.lsp.buf.range_formatting()<CR>",
      opts
    )
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false
    )
  end
end

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {"documentation", "detail", "additionalTextEdits"},
  }

  return {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {Lua = {diagnostics = {globals = {"vim"}}}},
  }
end

local function setup_servers()
  local installed_servers = lspinstall.installed_servers()
  local required_servers = {
    "bash",
    "css",
    "dockerfile",
    "elm",
    "go",
    "graphql",
    "html",
    "json",
    "lua",
    "python",
    "ruby",
    "rust",
    "typescript",
    "vim",
    "yaml",
  }
  for _, svr in pairs(required_servers) do
    if not vim.tbl_contains(installed_servers, svr) then
      lspinstall.install_server(svr)
    end
  end

  lspinstall.setup()
  installed_servers = lspinstall.installed_servers()

  for _, server in pairs(installed_servers) do
    local config = make_config()
    nvim_lsp[server].setup(config)
  end
end

setup_servers()

lspinstall.post_install_hook = function()
  setup_servers()
  vim.cmd("bufdo e")
end
