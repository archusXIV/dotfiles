--[[
lite-xl version 2.1.8-5
Put user settings here.
This module will be loaded after everything else when the application starts,
-- it will be automatically reloaded when saved and by pressing alt+shift+r to restart
--]]
------------------------------------------------------------------------------------------
----------------------------------------- GENERAL-----------------------------------------
----------------------------------------- LOCALS -----------------------------------------
local core = require "core"
local common = require "core.common"
local config = require "core.config"
local style = require "core.style"
local lintplus = require "plugins.lintplus"
----------------------------------------- CONFIG -----------------------------------------
config.borderless = false
config.blink_period = 0.5
config.draw_whitespace = true
config.indent_size = 4
config.line_limit = 100
config.max_project_files = 3000
config.max_tabs = 9
config.message_timeout = 7
config.tab_close_button = false
-------------------------------------------------------------------------------------------
----------------------------------------- PLUGINS -----------------------------------------
------------------------------ ENABLING/DISABLING ON THE FLY ------------------------------
config.plugins.autosave = true
config.plugins.foldblocks = true
config.plugins.linenumbers.hybrid = true
config.plugins.terminal = true
-------------------------------------- AUTOCOMPLETE ---------------------------------------
config.plugins.autocomplete = {
    ["min_len"] = 3,
    ["max_height"] = 12,
    ["desc_font_size"] = 18,
    ["max_suggestions"] = 6
}
------------------------------------ DRAW WHITE SPACES ------------------------------------
-- this is a system-wide config and it is disabled by default
if config.draw_whitespace == true then
    config.plugins.drawwhitespace = {
        ["enabled"]        = true,
        ["show_leading"]   = false,
        ["show_middle"]    = false,
        ["show_trailing"]  = true,
        ["trailing_error"] = true,
        ["leading_color"]  = { common.color "#3b7aba" },
        ["middle_color"]   = { common.color "#3b7aba" },
        ["trailing_color"] = { common.color "#e3b71d" }
    }
end
--------------------------------------- FOLDBLOCKS ----------------------------------------
if config.plugins.foldblocks == true then
    config.plugins.foldblocks = {
        ["indicators"] = true,
        ["min_lines"] = 1,
        ["indicator_symbols"] = "+-"
    }
-- config.plugins.foldblocks.indicator_open  = "<>"
-- config.plugins.foldblocks.indicator_close = "< >"
end
---------------------------------------- TERMINAL ----------------------------------------
if config.plugins.terminal == true then
    config.plugins.terminal = {
        ["background"]    = { common.color "#000000" },
        ["text"]          = { common.color "#79c8c5" },
        ["drawer_height"] = 400
    }
end
----------------------------------------- LINT+ ------------------------------------------
lintplus.load("shellcheck")
lintplus.setup.lint_on_doc_load()
lintplus.setup.lint_on_doc_save()

style.lint = {
    ["info"]    = { common.color "#3b7aba" },
    ["hint"]    = { common.color "#79c8c5" },
    ["warning"] = { common.color "#e3b71d" },
    ["error"]   = { common.color "#ff3c41" }
}
------------------------------------------------------------------------------------------
--------------------------------------- THEMES -------------------------------------------
local themes_list = {
    -- dark
    "archlabs", "blacksea", "bwr", "crocus", "delt-dark", "embers-dark",
    "github-dark", "GmnFrost", "gruvbox-dark", "jb-fleet", "jellybeans",
    "monochrome-dark", "melle-julie", "nord", "predawn", "shadesofblue",
    "simplicity", "tokyo-night", "vim-like", "zenburn",
    -- lite
    "github-lite", "gruvbox-lite", "yousai-lite", "monochrome-lite"
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

apply_theme("vim-like")
------------------------------------------------------------------------------------------
------------------------------------------ FONTS -----------------------------------------
--[[
Available fonts:
CaskaydiaCoveNerdFontMono, FiraCode, Hack, IBMPlexMono,
JetBrainsMono, JetBrainsMonoNerdFont, JetBrainsMonoNerdFont{Mono,Propo},
JetBrainsMonoNL, JetBrainsMonoNLNerdFont{Mono,Propo},
LilexNerdFont{Mono,Propo},
MesloLGLDZNerdFont{Mono,Propo}, MesloLGLNerdFont{Mono,Propo},
MesloLGMDZNerdFont{Mono,Propo}, MesloLGMNerdFont{Mono,Propo},
MesloLGSDZNerdFont{Mono,Propo}, MesloLGSNerdFont{Mono,Propo}
--]]
----------------------------------------- names ------------------------------------------
local guiFont  = "Hack"
local codeFont = "FiraCode"
local funcFont = "FiraCode"
local keyFont  = "FiraCode"
----------------------------------------- styles -----------------------------------------
local Regular    = "-Regular.ttf"
local Italic     = "-Italic.ttf"
local Bold       = "-Bold.ttf"
local BoldItalic = "-BoldItalic.ttf"
----------------------------------------- sizes ------------------------------------------
local guiFontSize    = 15
local regularSize    = 19
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
local fontOptions = { antialiasing="subpixel", hinting="slight" }
local com = loadFont(ttfPath .. guiFont .. Italic, italicSize, fontOptions)
local key = loadFont(get_font_path(keyFont, "-SemiBold.ttf", Bold), boldSize, fontOptions)
local fun = loadFont(get_font_path(funcFont, "-Regular.ttf", BoldItalic), boldItalicSize, fontOptions)

style.syntax_fonts = {
    ["comment"]  = com,
    ["keyword"]  = key,
    ["function"] = fun
}

style.font = loadFont(ttfPath .. guiFont .. Italic, guiFontSize * SCALE, fontOptions)
style.code_font = loadFont(ttfPath .. codeFont .. Regular, regularSize * SCALE, fontOptions)
