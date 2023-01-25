local wilder = require("wilder")

local find_cmd_for = function(type)
	if vim.fn.executable("fd") == 1 then
		return { "fd", "--type", type, "--hidden", "--follow", "--exclude", ".git" }
	else
		return { "find", ".", "-type", type, "-printf", "%P\n" }
	end
end

local highlights_for = function(mode)
	local fmt = { foreground = "#ab47bc", bold = true }
	if mode == "Popup" then
		fmt.background = "#eff1f4"
	end
	if mode == "Mini" then
		fmt.background = "#d0d3dc"
	end
	return {
		border = "Normal",
		accent = wilder.make_hl("WilderAccent" .. mode, "Pmenu", { { a = 1 }, { a = 1 }, fmt }),
	}
end

wilder.setup({ modes = { ":", "/" } })

wilder.set_option("pipeline", {
	wilder.branch(
		wilder.python_file_finder_pipeline({
			file_command = find_cmd_for("f"),
			dir_command = find_cmd_for("d"),
			filters = { "fuzzy_filter", "difflib_sorter" },
		}),
		wilder.cmdline_pipeline({ fuzzy = 2 }),
		wilder.python_search_pipeline({ pattern = "fuzzy" })
	),
})

local popup = wilder.popupmenu_renderer(wilder.popupmenu_palette_theme({
	border = "rounded",
	highlighter = wilder.basic_highlighter(),
	highlights = highlights_for("Popup"),
}))

local mini = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
	highlighter = wilder.basic_highlighter(),
	highlights = highlights_for("Mini"),
	border = "rounded",
}))

wilder.set_option(
	"renderer",
	wilder.renderer_mux({
		[":"] = popup,
		["/"] = mini,
		substitute = mini,
	})
)
