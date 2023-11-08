local wilder = require("wilder")
wilder.setup({ modes = { ":", "/" } })
wilder.set_option("use_python_remote_plugin", 0)
wilder.set_option("pipeline", {
	wilder.branch(wilder.cmdline_pipeline({
		fuzzy = 2,
		fuzzy_filter = wilder.lua_fzy_filter(),
	})),
})
wilder.set_option(
	"renderer",
	wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
		highlights = {
			border = "Normal",
			accent = "Special",
		},
		border = "rounded",
		highlighter = wilder.basic_highlighter(),
		left = { " ", wilder.popupmenu_devicons() },
	}))
)
