-- lite-xl version 2.0.1-1
-- put user settings here
-- this module will be loaded after everything else when the application starts
-- it will be automatically reloaded when saved

local core = require "core"
local keymap = require "core.keymap"
local config = require "core.config"
local style = require "core.style"

config.message_timeout = 20
config.treeview_size = 350 * SCALE
config.max_tabs = 9
config.indent_size = 4

-- THEMES:
-- core.reload_module("colors.summer")
-- core.reload_module("colors.ashes-dark")
-- core.reload_module("colors.codeschool")
-- core.reload_module("colors.crocus")
-- core.reload_module("colors.dracula")
-- core.reload_module("colors.vscode-dark")
-- core.reload_module("colors.embers-dark")
core.reload_module("colors.barrett")
-- core.reload_module("colors.zenburn")

-- CUSTOM OR ACTIVE KEY BINDINGS:
-- ~/.config/lite-xl/keybindings.lua
core.reload_module("keybindings")

-- customize fonts:
style.font = renderer.font.load("/usr/share/fonts/TTF/Hack-Regular.ttf", 14 * SCALE)
style.code_font = renderer.font.load("/usr/share/fonts/TTF/Hack-Regular.ttf", 15 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/DejaVuSansMono.ttf", 15.5 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/FantasqueSansMono-Regular.ttf", 18.5 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/iosevka-regular.ttf", 20 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/Monoid-Regular.ttf", 12 * SCALE, {hinting="full"})
-- style.code_font = renderer.font.load("/usr/share/lite-xl/fonts/JetBrainsMono-Regular.ttf", 13.5 * SCALE, {hinting="full"})
-- style.icon_font = renderer.font.load("/usr/share/fonts/OTF/Font Awesome.otf", 20  *SCALE, {antialiasing="subpixel", hinting="full"})
-- fonts used by the editor:
-- style.font      : user interface
-- style.big_font  : big text in welcome screen
-- style.icon_font : icons
-- style.code_font : code
--
-- the function to load the font accept a 3rd optional argument like:
--
-- {antialiasing="grayscale", hinting="full"}
--
-- possible values are:
-- antialiasing: grayscale, subpixel
-- hinting: none, slight, full
