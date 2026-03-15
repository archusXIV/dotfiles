--[[
lite-xl version 2.1.8-2
put user settings here
this module will be loaded after everything else when the application starts
it will be automatically reloaded when saved and by pressing alt+r to restart
--]]

local core = require "core"
local common = require "core.common"
local config = require "core.config"
local style = require "core.style"
local lintplus = require "plugins.lintplus"

config.borderless = false
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
    ["max_suggestions"] = 12,
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
local themes_list = {
    -- dark
    "archlabs", "blacksea", "embers-dark", "gruvbox-dark", "monochrome-dark",
    "melle-julie", "nord", "predawn", "simplicity", "tokyo-night", "zenburn",
    -- lite
    "github-lite", "gruvbox-lite", "yousai-lite", "monochrome-lite",
}

local themes = {}
for _, theme in ipairs(themes_list) do
    themes[theme] = true
end

-- /usr/share/lite-xl/colors/default.lua
local default_theme = "default"

local function apply_theme(name)
    if themes[name] then
        core.reload_module("colors." .. name)
    else
        -- Apply the default if the chosen theme does not exist in the list.
        core.reload_module("colors." .. default_theme)
    end
end

apply_theme("tokyo-night")

------------------------------------------ FONTS -----------------------------------------
--[[
Available fonts:
CaskaydiaCoveNerdFontMono, Hack, IBMPlexMono,
JetBrainsMono, JetBrainsMonoNerdFont, JetBrainsMonoNerdFont{Mono,Propo},
JetBrainsMonoNL, JetBrainsMonoNLNerdFont{Mono,Propo},
LilexNerdFont{Mono,Propo},
MesloLGLDZNerdFont{Mono,Propo}, MesloLGLNerdFont{Mono,Propo},
MesloLGMDZNerdFont{Mono,Propo}, MesloLGMNerdFont{Mono,Propo},
MesloLGSDZNerdFont{Mono,Propo}, MesloLGSNerdFont{Mono,Propo}
--]]
----------------------------------------- names ------------------------------------------
local guiFont  = "Hack"
local codeFont = "LilexNerdFontMono"
local funcFont = "LilexNerdFontMono"
local keyFont  = "LilexNerdFontMono"
----------------------------------------- styles -----------------------------------------
local Regular    = "-Regular.ttf"
local Italic     = "-Italic.ttf"
local Bold       = "-Bold.ttf"
local BoldItalic = "-BoldItalic.ttf"
----------------------------------------- sizes ------------------------------------------
local guiFontSize    = 14
local regularSize    = 16
local italicSize     = regularSize
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

local ttfPath = "/usr/share/fonts/TTF/"
-- Get the appropriate font variant path
local function get_font_path(font, variant, fallback)
    local path = ttfPath .. font .. variant
    if font_exists(path) then
        return path
    end
    return ttfPath .. font .. fallback
end
-------------------------------------- Definitions ---------------------------------------
local loadFont = (renderer.font.load)
-- com = comment, key = keyword, fun = function
-- antialiasing="grayscale" or antialiasing="subpixel", hinting="slight" or hinting="full"
local readability = { antialiasing="grayscale", hinting="slight" }
local com = loadFont(ttfPath .. guiFont .. Italic, italicSize, readability)
local key = loadFont(get_font_path(keyFont, "-SemiBold.ttf", Bold), boldSize, readability)
local fun = loadFont(get_font_path(funcFont, "-Regular.ttf", BoldItalic), boldItalicSize, readability)

style.syntax_fonts = {
    ["comment"]  = com,
    ["keyword"]  = key,
    ["function"] = fun,
}

style.font = loadFont(ttfPath .. guiFont .. Italic, guiFontSize * SCALE, readability)
style.code_font = loadFont(ttfPath .. codeFont .. Regular, regularSize * SCALE, readability)