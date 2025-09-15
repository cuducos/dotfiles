vim.keymap.set("n", "<Leader>,", "<Cmd>nohl<CR>")
vim.keymap.set("n", "vv", "viw")
vim.keymap.set("n", "<Leader>w", ":w<CR>")
vim.keymap.set("n", "<Leader>wq", function()
	vim.cmd("w")
	vim.cmd("bd")
end)

-- buffer and split management
vim.keymap.set("n", "<Leader>qa", "<Cmd>bufdo bw<CR>")
vim.keymap.set("n", "<Leader>q", "<Cmd>bw<CR>")
vim.keymap.set("n", "<Home>", "<C-w>h")
vim.keymap.set("n", "<End>", "<C-w>l")
vim.keymap.set("n", "<PageUp>", "<C-w>k")
vim.keymap.set("n", "<PageDown>", "<C-w>j")

-- indent and keep selection
vim.keymap.set("", ">", ">gv", {})
vim.keymap.set("", "<", "<gv", {})

-- move lines up and down
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- stop c, s and d from yanking
vim.keymap.set("n", "c", [["_c]])
vim.keymap.set("x", "c", [["_c]])
vim.keymap.set("n", "s", [["_s]])
vim.keymap.set("x", "s", [["_s]])
vim.keymap.set("n", "d", [["_d]])
vim.keymap.set("x", "d", [["_d]])

-- stop p from overwtitting the register (by re-yanking it)
vim.keymap.set("x", "p", "pgvy")

-- keep centered when n/N/J
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "J", "mzJ`z")

-- relative numbers
vim.keymap.set("n", "#", function()
	vim.o.relativenumber = not vim.o.relativenumber
end)

-- go to github
vim.keymap.set("n", "gh", function()
	local repo = vim.fn.expand("<cfile>")
	if not string.find(repo, "^[a-zA-Z0-9-_.]*/[a-zA-Z0-9-_.]*$") then
		return
	end

	local url = "https://github.com/" .. repo
	local cmd = "xdg-open"
	if vim.fn.has("mac") == 1 then
		cmd = "open"
	end

	vim.fn.jobstart({ cmd, url }, { detach = true })
end)

-- select the end of the line without linebreak
vim.keymap.set("v", "$", "$h")
vim.keymap.set("n", "<cr>", function()
	local path = vim.fn.expand("<cfile>")
	local buf = vim.api.nvim_get_current_buf()
	local cwd = vim.api.nvim_buf_get_name(buf):match("(.*/)")

	local handler = io.open(cwd .. path)
	if handler == nil then
		return "<cr>"
	end

	handler:close()
	return "gF"
end)

-- disable folding
local fold_keys = { "zf", "zF", "zd", "zE", "za", "zA", "zo", "zO", "zc", "zC", "zx", "zX", "zm", "zM", "zr", "zR" }
for _, key in ipairs(fold_keys) do
	local existing_map = vim.fn.maparg(key, "n")
	if existing_map ~= "" then
		vim.keymap.del("n", key)
	end
end
if vim.fn.maparg("zf", "v") ~= "" then
	vim.keymap.del("v", "zf")
end
