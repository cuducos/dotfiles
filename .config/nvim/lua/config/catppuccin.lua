-- set flavour (light/dark) based on time of day
local sunrise_by_season = {
	winter = 7,
	spring = 6,
	summer = 5,
	fall = 7,
}

local sunset_by_season = {
	winter = 16,
	spring = 19,
	summer = 20,
	fall = 17,
}

local season = function(month)
	if month >= 3 and month <= 5 then
		return "spring"
	elseif month >= 6 and month <= 8 then
		return "summer"
	elseif month >= 9 and month <= 11 then
		return "fall"
	else
		return "winter"
	end
end

local is_dark = function()
	local date = os.date("*t")
	local hour = date.hour
	local month = date.month
	local season = season(month)
	local sunrise = sunrise_by_season[season]
	local sunset = sunset_by_season[season]

	if hour >= sunset or hour <= sunrise then
		return true
	else
		return false
	end
end

if is_dark() then
	vim.g.catppuccin_flavour = "frappe"
else
	vim.g.catppuccin_flavour = "latte"
end

local colors = require("catppuccin.palettes").get_palette()
require("catppuccin").setup({
	integrations = {
		cmp = true,
		gitsigns = true,
		lsp_trouble = true,
		mason = true,
		neogit = true,
		notify = true,
		nvimtree = true,
		pounce = true,
		telescope = true,
		treesitter = true,
		treesitter_context = true,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = true,
		},
	},
	custom_highlights = {
		NotifyINFOTitle = { fg = colors.sky, style = {} },
	},
})

vim.cmd("colorscheme catppuccin")

-- set float window background color to the same as the normal window
vim.cmd("highlight NormalFloat guifg=#4c4f69 guibg=#eff1f5")
