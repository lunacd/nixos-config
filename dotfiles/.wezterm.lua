local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Color scheme
config.color_scheme = 'Catppuccin Mocha'

-- WSL
config.default_domain = 'WSL:NixOS'

-- Font
config.font = wezterm.font 'MonaspiceNe Nerd Font Mono'
config.font_size = 10
config.keys = {
    {
        key = '\\',
        mods = 'CTRL',
        action = wezterm.action.SplitHorizontal
    },
    {
        key = '-',
        mods = 'CTRL',
        action = wezterm.action.SplitVertical
    },
    {
        key = 'f',
        mods = 'CTRL',
        action = wezterm.action.ToggleFullScreen
    },
    {
        key = 'n',
        mods = 'CTRL',
        action = wezterm.action.SpawnTab 'DefaultDomain'
    },
}

for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'ALT',
        action = wezterm.action.ActivateTab(i - 1),
    })
end

return config
