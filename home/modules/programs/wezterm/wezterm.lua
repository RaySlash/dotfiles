local wezterm = require("wezterm")
local sessionizer = require("sessionizer")

return {
	font = wezterm.font_with_fallback({
		"IosevkaTerm Nerd Font",
		"Atkinson Hyperlegible",
	}),
	font_size = 14.0,
	color_scheme = "kanagawa_custom",
	use_ime = true,
	enable_kitty_keyboard = true,
	window_background_opacity = 0.7,
	window_decorations = "NONE",
	window_close_confirmation = "NeverPrompt",
	enable_tab_bar = false,
	webgpu_power_preference = "HighPerformance",
	check_for_updates = false,
	enable_wayland = true,
	max_fps = 165,
	anti_alias_custom_block_glyphs = true,
	default_cursor_style = "SteadyBlock",
	warn_about_missing_glyphs = true,
	tiling_desktop_environments = {
		"Wayland Hyprland",
	},
	window_padding = {
		left = "0px",
		right = "0px",
		top = "0px",
		bottom = "0px",
	},
	hyperlink_rules = {
		-- Matches: a URL in parens: (URL)
		{
			regex = "\\((\\w+://\\S+)\\)",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in brackets: [URL]
		{
			regex = "\\[(\\w+://\\S+)\\]",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in curly braces: {URL}
		{
			regex = "\\{(\\w+://\\S+)\\}",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in angle brackets: <URL>
		{
			regex = "<(\\w+://\\S+)>",
			format = "$1",
			highlight = 1,
		},
		-- Then handle URLs not wrapped in brackets
		{
			regex = "\\b\\w+://\\S+[)/a-zA-Z0-9-]+",
			format = "$0",
		},
		-- implicit mailto link
		{
			regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
			format = "mailto:$0",
		},
	},
	keys = {
		{
			key = "\\",
			mods = "ALT",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "Q",
			mods = "ALT|SHIFT",
			action = wezterm.action.CloseCurrentPane({ confirm = false }),
		},
		{
			key = "RightArrow",
			mods = "ALT|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},
		{
			key = "LeftArrow",
			mods = "ALT|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Left"),
		},
		{
			key = "q",
			mods = "ALT",
			action = wezterm.action.CloseCurrentTab({ confirm = false }),
		},
		{
			key = "a",
			mods = "ALT",
			action = wezterm.action.SpawnTab("DefaultDomain"),
		},
		{
			key = "c",
			mods = "ALT",
			action = wezterm.action.ActivateCommandPalette,
		},
		{
			key = "/",
			mods = "ALT",
			action = wezterm.action.Search("CurrentSelectionOrEmptyString"),
		},
		{
			key = "s",
			mods = "ALT",
			action = wezterm.action.ShowTabNavigator,
		},
		-- Sessionizer Bindings
		{ key = "f", mods = "ALT", action = wezterm.action_callback(sessionizer.toggle) },
		-- { key = "F", mods = "ALT", action = wezterm.action_callback(sessionizer.resetCacheAndToggle) },
	},
}
