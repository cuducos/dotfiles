local notify = require("notify")
notify.setup({ background_colour = "#eff1f5" })
vim.notify = notify

local mappings = {
	{ "n", "<leader>.", vim.notify.dismiss },
	{
		"n",
		"<leader>!",
		function()
			local register = [["]]
			local notifications = vim.notify.history()
			local last = notifications[#notifications]
			local contents = table.concat(last.message, "\n")
			vim.cmd(string.format("call setreg('%s', '%s')", register, contents))
		end,
	},
}
for _, mapping in pairs(mappings) do
	vim.keymap.set(unpack(mapping))
end

-- set spinner for ptogress status
local spinner_chars = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local lsp_client_notifications = {}
local notification_data = function(client_id, token)
	if not lsp_client_notifications[client_id] then
		lsp_client_notifications[client_id] = {}
	end

	if not lsp_client_notifications[client_id][token] then
		lsp_client_notifications[client_id][token] = {}
	end

	return lsp_client_notifications[client_id][token]
end

local update_spinner = function(client_id, token)
	local data = notification_data(client_id, token)

	if data.spinner then
		local spinner = (data.spinner + 1) % #spinner_chars

		data.spinner = spinner
		data.notification = vim.notify(nil, nil, {
			hide_from_history = true,
			icon = spinner_chars[spinner],
			replace = data.notification,
		})
	end
end

local title = function(title, client_name)
	return client_name .. (#title > 0 and ": " .. title or "")
end

local message = function(message, percentage)
	return (percentage and percentage .. "%\t" or "") .. (message or "")
end

-- lsp progress
vim.lsp.handlers["$/progress"] = function(_, result, ctx)
	if not result.value.kind then
		return
	end

	local data = notification_data(ctx.client_id, result.token)
	local msg = message(result.value.message, result.value.percentage)

	local config = {}
	if result.value.kind == "begin" then
		config = {
			title = title(result.value.title, vim.lsp.get_client_by_id(ctx.client_id).name),
			icon = spinner_chars[1],
			timeout = false,
			hide_from_history = false,
		}
	elseif result.value.kind == "report" and data then
		config = {
			replace = data.notification,
			hide_from_history = false,
		}
	elseif result.value.kind == "end" and data then
		config = {

			icon = "",
			replace = data.notification,
			timeout = 3000,
		}
		msg = msg or "Complete"
	end
	data.notification = vim.notify(msg, "info", config)

	if result.value.kind == "begin" then
		data.spinner = 1
		update_spinner(ctx.client_id, result.token)
		vim.defer_fn(function()
			update_spinner(ctx.client_id, result.token)
		end, 250)
	elseif result.value.kind == "end" and data then
		data.spinner = nil
	end
end

-- lsp messages
local severity = { "error", "warn", "info", "info" } -- map hint and info to info
vim.lsp.handlers["window/showMessage"] = function(_, method, params, _)
	vim.notify(method.message, severity[params.type])
end
