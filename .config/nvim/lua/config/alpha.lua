local path = require("plenary.path")

local headers = {
	{

		[[                       _     _                          ]],
		[[                      (_)   | |                         ]],
		[[    ___ ___  _ __  ___ _ ___| |_ ___ _ __   ___ _   _   ]],
		[[   / __/ _ \| '_ \/ __| / __| __/ _ \ '_ \ / __| | | |  ]],
		[[  | (_| (_) | | | \__ \ \__ \ ||  __/ | | | (__| |_| |  ]],
		[[   \___\___/|_| |_|___/_|___/\__\___|_| |_|\___|\__, |  ]],
		[[                                                 __/ |  ]],
		[[          _ ___    __ _ _   _  ___  ___ _ __    |___/   ]],
		[[         | / __|  / _` | | | |/ _ \/ _ \ '_ \           ]],
		[[         | \__ \ | (_| | |_| |  __/  __/ | | |          ]],
		[[         |_|___/  \__, |\__,_|\___|\___|_| |_|          ]],
		[[                     | |                                ]],
		[[                     |_|                                ]],
	},
	{
		[[ ┌─┐┌─┐┌┐┌┌─┐┬┌─┐┌┬┐┌─┐┌┐┌┌─┐┬ ┬ ]],
		[[ │  │ ││││└─┐│└─┐ │ ├┤ ││││  └┬┘ ]],
		[[ └─┘└─┘┘└┘└─┘┴└─┘ ┴ └─┘┘└┘└─┘ ┴  ]],
		[[          ┬┌─┐  ┌─┐ ┬ ┬┌─┐┌─┐┌┐┌ ]],
		[[          │└─┐  │─┼┐│ │├┤ ├┤ │││ ]],
		[[          ┴└─┘  └─┘└└─┘└─┘└─┘┘└┘ ]],
	},
	{
		[[                                        ███           █████                                            ]],
		[[                                       ░░░           ░░███                                             ]],
		[[   ██████   ██████  ████████    █████  ████   █████  ███████    ██████  ████████    ██████  █████ ████ ]],
		[[  ███░░███ ███░░███░░███░░███  ███░░  ░░███  ███░░  ░░░███░    ███░░███░░███░░███  ███░░███░░███ ░███  ]],
		[[ ░███ ░░░ ░███ ░███ ░███ ░███ ░░█████  ░███ ░░█████   ░███    ░███████  ░███ ░███ ░███ ░░░  ░███ ░███  ]],
		[[ ░███  ███░███ ░███ ░███ ░███  ░░░░███ ░███  ░░░░███  ░███ ███░███░░░   ░███ ░███ ░███  ███ ░███ ░███  ]],
		[[ ░░██████ ░░██████  ████ █████ ██████  █████ ██████   ░░█████ ░░██████  ████ █████░░██████  ░░███████  ]],
		[[  ░░░░░░   ░░░░░░  ░░░░ ░░░░░ ░░░░░░  ░░░░░ ░░░░░░     ░░░░░   ░░░░░░  ░░░░ ░░░░░  ░░░░░░    ░░░░░███  ]],
		[[                                                                                             ███ ░███  ]],
		[[                                                                                            ░░██████   ]],
		[[                                                                                             ░░░░░░    ]],
		[[                ███                                                                                    ]],
		[[               ░░░                                                                                     ]],
		[[               ████   █████      ████████ █████ ████  ██████   ██████  ████████                        ]],
		[[               ░███  ███░░      ███░░███ ░░███ ░███  ███░░███ ███░░███░░███░░███                       ]],
		[[               ░███ ░░█████    ░███ ░███  ░███ ░███ ░███████ ░███████  ░███ ░███                       ]],
		[[               ░███  ░░░░███   ░███ ░███  ░███ ░███ ░███░░░  ░███░░░   ░███ ░███                       ]],
		[[               █████ ██████    ░░███████  ░░████████░░██████ ░░██████  ████ █████                      ]],
		[[               ░░░░ ░░░░░░      ░░░░░███   ░░░░░░░░  ░░░░░░   ░░░░░░  ░░░░ ░░░░░                       ]],
		[[                                    ░███                                                               ]],
		[[                                    █████                                                              ]],
		[[                                   ░░░░░                                                               ]],
	},
}
local header = {
	type = "text",
	val = headers[math.random(#headers)],
	opts = { position = "center", hl = "Debug" },
}

local function menu_item(path, shortcut, short, autocd)
	short = short or path
	local icon
	local button_hl = {}

	if nvim_web_devicons.enabled then
		local ico, hl = icon(path)
		local hl_option_type = type(nvim_web_devicons.highlight)
		if hl_option_type == "boolean" then
			if hl and nvim_web_devicons.highlight then
				table.insert(button_hl, { hl, 0, 3 })
			end
		end
		if hl_option_type == "string" then
			table.insert(button_hl, { nvim_web_devicons.highlight, 0, 3 })
		end
		icon = ico .. "  "
	else
		icon = ""
	end
	local cd_cmd = (autocd and " | cd %:p:h" or "")
	local file_button_el = dashboard.button(shortcut, icon .. short, "<cmd>e " .. path .. cd_cmd .. " <CR>")
	local fn_start = short:match(".*[/\\]")
	if fn_start ~= nil then
		table.insert(button_hl, { "Comment", #icon - 2, #fn_start + #icon })
	end
	file_button_el.opts.hl = button_hl
	return file_button_el
end

local default_mru_ignore = { "gitcommit" }

local mru_opts = {
	ignore = function(path, ext)
		return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
	end,
	autocd = false,
}

local function recent_files()
	local paths = {}
	for _, pth in pairs(vim.v.oldfiles) do
		if #paths == 14 then
			break
		end
		if vim.fn.filereadable(pth) == 1 then
			paths[#paths + 1] = pth
		end
	end

	local target_width = 42
	local tbl = {}
	for idx, pth in ipairs(paths) do
		local short = vim.fn.fnamemodify(pth, ":~")
		if #short > target_width then
			short = plenary_path.new(short):shorten(1, { -2, -1 })
			if #short > target_width then
				short = path.new(short):shorten(1, { -1 })
			end
		end
		local shortcut = tostring(idx + start)
		local file_button_el = menu_item(pth, shortcut, short, opts.autocd)
		tbl[idx] = file_button_el
	end
	return {
		type = "group",
		val = tbl,
		opts = {},
	}
end

local config = require("alpha.themes.theta").config
config.layout[2] = header
config.layout[6].val = {
	config.layout[6].val[1],
	config.layout[6].val[2],
	config.layout[6].val[3],
	config.layout[6].val[7],
	config.layout[6].val[8],
}

require("alpha").setup(config)
