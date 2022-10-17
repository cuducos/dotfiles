local notify = require("notify")
notify.setup({ render = "minimal" })
vim.keymap.set("n", "<leader>.", require("notify").dismiss)
vim.notify = function(msg, ...)
	if msg == nil or string.match(msg, [[^%s*$]]) then
		return
	end
	if arg == nil then
		arg = {}
	end
	notify(msg, unpack(arg))
end

local severity = { "error", "warn", "info", "info" } -- map hint and info to info
vim.lsp.handlers["window/showMessage"] = function(_, method, params, _)
	vim.notify(method.message, severity[params.type])
end
