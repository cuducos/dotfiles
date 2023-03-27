local dashboard = require("alpha.themes.dashboard")

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

local buttons = {
	type = "group",
	val = {
		{ type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
		{ type = "padding", val = 1 },
		dashboard.button("e", "  New file", "<cmd>ene<CR>"),
		dashboard.button("SPC f f", "  Find file"),
		dashboard.button("SPC f g", "  Live grep"),
		dashboard.button("c", "  Configuration", "<cmd>cd ~/.config/nvim/ <CR>"),
		dashboard.button("u", "  Update plugins", "<cmd>PackerSync<CR>"),
		dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
	},
	position = "center",
}

local config = require("alpha.themes.theta").config
config.layout[2] = header
config.layout[6].val = {
	config.layout[6].val[1],
	config.layout[6].val[2],
	dashboard.button("i", "  New file", "<cmd>ene<CR>"),
	config.layout[6].val[7],
	config.layout[6].val[8],
}

require("alpha").setup(config)
