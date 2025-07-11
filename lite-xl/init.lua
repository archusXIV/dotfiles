--[[
lite-xl version 2.1.8-2
put user settings here
this module will be loaded after everything else when the application starts
it will be automatically reloaded when saved
--]]

local core = require "core"
local common = require "core.common"
local config = require "core.config"
local style = require "core.style"
local lintplus = require "plugins.lintplus"

config.max_project_files = 3000
config.message_timeout = 7
config.max_tabs = 9
config.indent_size = 4
config.line_limit = 100
config.blink_period = 0.8
config.draw_whitespace = true
config.plugins.exterm = false
config.plugins.linenumbers.hybrid = true
-- config.plugins.terminal = false

config.plugins.autocomplete = {
    ["min_len"] = 3,
    ["max_height"] = 12,
    ["desc_font_size"] = 18,
    ["max_suggestions"] = 36,
}

----------------------------------------- LINT+ ------------------------------------------
lintplus.load("shellcheck")
lintplus.setup.lint_on_doc_load()
lintplus.setup.lint_on_doc_save()

style.lint = {
    ["info"]    = { common.color "#3b7aba" },
    ["hint"]    = { common.color "#79c8c5" },
    ["warning"] = { common.color "#e3b71d" },
    ["error"]   = { common.color "#ff3c41" },
}

--------------------------------------- THEMES -------------------------------------------
---------------------------------------- dark --------------------------------------------
-- core.reload_module("colors.archlabs")
-- core.reload_module("colors.aurora")
-- core.reload_module("colors.blacksea")
-- core.reload_module("colors.betelgeuse")
-- core.reload_module("colors.embers-dark")
-- core.reload_module("colors.gruvbox_dark")
-- core.reload_module("colors.monochrome-dark")
-- core.reload_module("colors.predawn")
-- core.reload_module("colors.simplicity")
-- core.reload_module("colors.winter")

----------------------------------------- lite -------------------------------------------
-- core.reload_module("colors.github")
-- core.reload_module("colors.gruvbox_light")
core.reload_module("colors.yousai-lite")
-- core.reload_module("colors.monochrome-lite")

------------------------------------------ FONTS -----------------------------------------
local loadFont = (renderer.font.load)
local ttfPath = "/usr/share/fonts/TTF/"

-- Available fonts:
-- CaskaydiaCoveNerdFontMono, Hack, IBMPlexMono,
-- JetBrainsMono, JetBrainsMonoNerdFont, JetBrainsMonoNerdFont{Mono,Propo},
-- JetBrainsMonoNL, JetBrainsMonoNLNerdFont{Mono,Propo},
-- Montserrat{Alternates},
-- MesloLGLDZNerdFont{Mono,Propo}, MesloLGLNerdFont{Mono,Propo},
-- MesloLGMDZNerdFont{Mono,Propo}, MesloLGMNerdFont{Mono,Propo},
-- MesloLGSDZNerdFont{Mono,Propo}, MesloLGSNerdFont{Mono,Propo}

-------------------------------------- fonts names ---------------------------------------
local guiFont  = "Hack"
local codeFont = "MesloLGSDZNerdFontPropo"
local funcFont = "IBMPlexMono"
local keyFont  = "JetBrainsMonoNerdFontPropo"

----------------------------------------- styles -----------------------------------------
local Regular    = "-Regular.ttf"
local Italic     = "-Italic.ttf"
local Bold       = "-Bold.ttf"
local BoldItalic = "-BoldItalic.ttf"

----------------------------------------- sizes ------------------------------------------
local guiFontSize    = 14
local regularSize    = 18
local italicSize     = 16
local boldSize       = regularSize
local boldItalicSize = boldSize

--------------------------------------- Functions ----------------------------------------
-- Check if font file exists
local function font_exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- Get the appropriate font variant path
local function get_font_path(font, variant, fallback)
    local path = ttfPath .. font .. variant
    if font_exists(path) then
        return path
    end
    return ttfPath .. font .. fallback
end

-------------------------------------- Definitions ---------------------------------------
-- com = comment, key = keyword, fun = function
local com = loadFont(ttfPath .. codeFont .. Italic, italicSize)
local key = loadFont(get_font_path(keyFont, "-SemiBold.ttf", Bold), boldSize)
local fun = loadFont(get_font_path(funcFont, "-SemiBoldItalic.ttf", BoldItalic), boldItalicSize)

style.font = loadFont(ttfPath .. guiFont .. Italic, guiFontSize * SCALE)
style.code_font = loadFont(ttfPath .. codeFont .. Regular, regularSize * SCALE)

style.syntax_fonts = {
    ["comment"]  = com,
    ["keyword"]  = key,
    ["function"] = fun,
}

