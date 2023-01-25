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

local default_mru_ignore = { "gitcommit" }

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
