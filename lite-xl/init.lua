-- put user settings here
-- this module will be loaded after everything else when the application starts
-- it will be automatically reloaded when saved

local core = require "core"
local common = require "core.common"
local config = require "core.config"
local style = require "core.style"
local lintplus = require "plugins.lintplus"

config.message_timeout = 10
config.max_tabs = 9
config.indent_size = 4
config.line_limit = 100
config.blink_period = 0.8
config.draw_whitespace = true
config.plugins.exterm = false
config.plugins.linenumbers.hybrid = true
config.plugins.themes = false
-- config.plugins.terminal = false

config.plugins.autocomplete = {
    ["min_len"]        = 2,
    ["max_height"]     = 12,
    ["desc_font_size"] = 14,
}

---------------------- Lint+ ----------------------
lintplus.load("shellcheck")
lintplus.setup.lint_on_doc_load()
lintplus.setup.lint_on_doc_save()

style.lint = {
    ["info"]       = { common.color "#3b7aba" },
    ["hint"]       = { common.color "#79c8c5" },
    ["warning"]    = { common.color "#e3b71d" },
    ["error"]      = { common.color "#ff3c41" },
}

-------------------- Themes -----------------------
--------------------- dark ------------------------
-- core.reload_module("colors.archlabs")
-- core.reload_module("colors.aurora")
-- core.reload_module("colors.blacksea")
-- core.reload_module("colors.betelgeuse")
core.reload_module("colors.embers-dark")
-- core.reload_module("colors.gruvbox_dark")
-- core.reload_module("colors.monochrome-dark")
-- core.reload_module("colors.predawn")
-- core.reload_module("colors.winter")
---------------------- lite -----------------------
-- core.reload_module("colors.github")
-- core.reload_module("colors.gruvbox_light")

------------------------------------------ Fonts ----------------------------------------
-- customize fonts:Medium
style.font = renderer.font.load("/usr/share/fonts/TTF/FiraCode-Regular.ttf", 15 * SCALE)
style.code_font = renderer.font.load("/usr/share/fonts/TTF/JetBrainsMono-Regular.ttf", 19 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/IBMPlexMono-Regular.ttf", 19 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/VictorMonoNerdFont-Medium.ttf", 18 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/FiraCode-Regular.ttf", 18 * SCALE)
