" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time("Luarocks path setup", true)
local package_path_str = "/home/ellison/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/ellison/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/ellison/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/ellison/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/ellison/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time("Luarocks path setup", false)
time("try_loadstring definition", true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

time("try_loadstring definition", false)
time("Defining packer_plugins", true)
_G.packer_plugins = {
  ["formatter.nvim"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22modules.formatter\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/formatter.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  ["gruvbox.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/gruvbox.nvim"
  },
  kommentary = {
    config = { "\27LJ\2\n|\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\1 prefer_single_line_comments\2\fdefault\23configure_language\22kommentary.config\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/kommentary"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/lush.nvim"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\nd\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\0\1\0\1\fnumbers\14buffer_id\nsetup\15bufferline\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16modules.lsp\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nó\2\0\0\5\0\15\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0004\4\0\0=\4\a\3=\3\b\0025\3\t\0005\4\n\0=\4\v\3=\3\f\0025\3\r\0=\3\14\2B\0\2\1K\0\1\0\vindent\1\0\1\venable\2\26incremental_selection\fkeymaps\1\0\4\21node_incremental\6+\21node_decremental\6-\19init_selection\15<leader>is\22scope_incremental\6w\1\0\1\venable\2\14highlight\fdisable\1\0\1\venable\2\21ensure_installed\1\0\0\1\t\0\0\ago\vpython\blua\tyaml\tjson\15javascript\tbash\15typescript\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["telescope.nvim"] = {
    config = { '\27LJ\2\n–\3\0\0\f\0\v\0\0315\0\0\0004\1\6\0005\2\1\0>\0\4\2>\2\1\0015\2\2\0>\0\4\2>\2\2\0015\2\3\0>\0\4\2>\2\3\0015\2\4\0>\0\4\2>\2\4\0015\2\5\0>\0\4\2>\2\5\0016\2\6\0\18\4\1\0B\2\2\4H\5\a€6\a\a\0009\a\b\a9\a\t\a6\t\n\0\18\v\6\0B\t\2\0A\a\0\1F\5\3\3R\5÷K\0\1\0\vunpack\20nvim_set_keymap\bapi\bvim\npairs\1\4\0\0\6n\15<leader>//!<Cmd>Telescope live_grep<CR>\1\4\0\0\6n\14<leader>b\31<Cmd>Telescope buffers<CR>\1\4\0\0\6n\14<leader>f"<Cmd>Telescope find_files<CR>\1\4\0\0\6n\14<leader>G"<Cmd>Telescope git_status<CR>\1\4\0\0\6n\14<leader>g!<Cmd>Telescope git_files<CR>\1\0\1\fnoremap\2\0' },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-go"] = {
    config = { "\27LJ\2\nä\2\0\0\2\0\f\0%6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0)\1\1\0=\1\6\0006\0\0\0009\0\1\0)\1\1\0=\1\a\0006\0\0\0009\0\1\0)\1\1\0=\1\b\0006\0\0\0009\0\1\0)\1\1\0=\1\t\0006\0\0\0009\0\1\0)\1\1\0=\1\n\0006\0\0\0009\0\1\0)\1\0\0=\1\v\0K\0\1\0\21go_jump_to_error\27go_highlight_operators\27go_highlight_functions go_highlight_function_calls\24go_highlight_fields\29go_highlight_extra_types\14goimports\19go_fmt_command\20go_fmt_autosave\22go_auto_type_info\6g\bvim\0" },
    loaded = false,
    needs_bufread = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/opt/vim-go"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ"
  }
}

time("Defining packer_plugins", false)
-- Config for: kommentary
time("Config for kommentary", true)
try_loadstring("\27LJ\2\n|\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\1 prefer_single_line_comments\2\fdefault\23configure_language\22kommentary.config\frequire\0", "config", "kommentary")
time("Config for kommentary", false)
-- Config for: nvim-treesitter
time("Config for nvim-treesitter", true)
try_loadstring("\27LJ\2\nó\2\0\0\5\0\15\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0004\4\0\0=\4\a\3=\3\b\0025\3\t\0005\4\n\0=\4\v\3=\3\f\0025\3\r\0=\3\14\2B\0\2\1K\0\1\0\vindent\1\0\1\venable\2\26incremental_selection\fkeymaps\1\0\4\21node_incremental\6+\21node_decremental\6-\19init_selection\15<leader>is\22scope_incremental\6w\1\0\1\venable\2\14highlight\fdisable\1\0\1\venable\2\21ensure_installed\1\0\0\1\t\0\0\ago\vpython\blua\tyaml\tjson\15javascript\tbash\15typescript\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time("Config for nvim-treesitter", false)
-- Config for: telescope.nvim
time("Config for telescope.nvim", true)
try_loadstring('\27LJ\2\n–\3\0\0\f\0\v\0\0315\0\0\0004\1\6\0005\2\1\0>\0\4\2>\2\1\0015\2\2\0>\0\4\2>\2\2\0015\2\3\0>\0\4\2>\2\3\0015\2\4\0>\0\4\2>\2\4\0015\2\5\0>\0\4\2>\2\5\0016\2\6\0\18\4\1\0B\2\2\4H\5\a€6\a\a\0009\a\b\a9\a\t\a6\t\n\0\18\v\6\0B\t\2\0A\a\0\1F\5\3\3R\5÷K\0\1\0\vunpack\20nvim_set_keymap\bapi\bvim\npairs\1\4\0\0\6n\15<leader>//!<Cmd>Telescope live_grep<CR>\1\4\0\0\6n\14<leader>b\31<Cmd>Telescope buffers<CR>\1\4\0\0\6n\14<leader>f"<Cmd>Telescope find_files<CR>\1\4\0\0\6n\14<leader>G"<Cmd>Telescope git_status<CR>\1\4\0\0\6n\14<leader>g!<Cmd>Telescope git_files<CR>\1\0\1\fnoremap\2\0', "config", "telescope.nvim")
time("Config for telescope.nvim", false)
-- Config for: nvim-lspconfig
time("Config for nvim-lspconfig", true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16modules.lsp\frequire\0", "config", "nvim-lspconfig")
time("Config for nvim-lspconfig", false)
-- Config for: nvim-bufferline.lua
time("Config for nvim-bufferline.lua", true)
try_loadstring("\27LJ\2\nd\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\0\1\0\1\fnumbers\14buffer_id\nsetup\15bufferline\frequire\0", "config", "nvim-bufferline.lua")
time("Config for nvim-bufferline.lua", false)
-- Config for: formatter.nvim
time("Config for formatter.nvim", true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22modules.formatter\frequire\0", "config", "formatter.nvim")
time("Config for formatter.nvim", false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time("Defining lazy-load filetype autocommands", true)
vim.cmd [[au FileType go ++once lua require("packer.load")({'vim-go'}, { ft = "go" }, _G.packer_plugins)]]
time("Defining lazy-load filetype autocommands", false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time("Sourcing ftdetect script at: /home/ellison/.local/share/nvim/site/pack/packer/opt/vim-go/ftdetect/gofiletype.vim", true)
vim.cmd [[source /home/ellison/.local/share/nvim/site/pack/packer/opt/vim-go/ftdetect/gofiletype.vim]]
time("Sourcing ftdetect script at: /home/ellison/.local/share/nvim/site/pack/packer/opt/vim-go/ftdetect/gofiletype.vim", false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
