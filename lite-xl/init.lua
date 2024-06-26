-- put user settings here -- this module will be loaded after everything else when the application starts
-- it will be automatically reloaded when saved

local core = require "core"
local keymap = require "core.keymap"
local config = require "core.config"
local style = require "core.style"

config.message_timeout = 10
config.max_tabs = 9
config.indent_size = 4
config.line_limit = 100
config.blink_period = 0.8
config.draw_whitespace = true
-- config.plugins.exterm = false
config.plugins.terminal = false

------------------------------ Themes ----------------------------------------
------------------------------- dark -----------------------------------------
core.reload_module("colors.blacksea")
-- core.reload_module("colors.betelgeuse")
-- core.reload_module("colors.everforest")
-- core.reload_module("colors.embers-dark")
-- core.reload_module("colors.github-dark-dimmed")
-- core.reload_module("colors.github_dark")
-- core.reload_module("colors.gruvbox_dark")
-- core.reload_module("colors.jb-fleet")
-- core.reload_module("colors.jellybeans")
-- core.reload_module("colors.liqube")
-- core.reload_module("colors.mariana")
-- core.reload_module("colors.monochrome-dark")
-- core.reload_module("colors.monokai-pro-classic")
-- core.reload_module("colors.monokai-sublime")
-- core.reload_module("colors.monokai")
-- core.reload_module("colors.nord")
-- core.reload_module("colors.onedark")
-- core.reload_module("colors.plasma")
-- core.reload_module("colors.predawn")
-- core.reload_module("colors.solarized_dark")
-- core.reload_module("colors.tokyo-night-vscode")
-- core.reload_module("colors.tokyo-night")
-- core.reload_module("colors.vscode-dark")
-- core.reload_module("colors.winter")
-- core.reload_module("colors.zenburn")
------------------------------- lite -----------------------------------------
-- core.reload_module("colors.catppuccin-latte")
-- core.reload_module("colors.flexoki_light")
-- core.reload_module("colors.github")
-- core.reload_module("colors.gruvbox_light")
-- core.reload_module("colors.monochrome-lite")

--------------------------- Key bindings -------------------------------------
keymap.add_direct {
    ["ctrl+q"]               = "core:quit",
    ["ctrl+shift+p"]         = "core:find-command",
    ["ctrl+p"]               = "core:find-file",
    ["ctrl+o"]               = "core:open-file",
    ["ctrl+n"]               = "core:new-doc",
    ["ctrl+shift+c"]         = "core:change-project-folder",
    ["ctrl+shift+o"]         = "core:open-project-folder",
    ["alt+r"]                = "core:restart",
    ["ctrl+b"]               = "treeview:toggle",
    ["ctrl+shift+h"]         = "root:split-left",
    ["alt+shift+l"]          = "root:split-right",
    ["alt+shift+j"]          = "root:split-down",
    ["alt+shift+k"]          = "root:split-up",
    ["ctrl+w"]               = "root:close",
    ["ctrl+pageup"]          = "root:move-tab-left",
    ["ctrl+pagedown"]        = "root:move-tab-right",
    ["alt+j"]                = "root:switch-to-left",
    ["alt+l"]                = "root:switch-to-right",
    ["alt+i"]                = "root:switch-to-up",
    ["alt+k"]                = "root:switch-to-down",
    ["ctrl+tab"]             = "root:switch-to-next-tab",
    ["ctrl+shift+tab"]       = "root:switch-to-previous-tab",
    ["alt+1"]                = "root:switch-to-tab-1",
    ["alt+2"]                = "root:switch-to-tab-2",
    ["alt+3"]                = "root:switch-to-tab-3",
    ["alt+4"]                = "root:switch-to-tab-4",
    ["alt+5"]                = "root:switch-to-tab-5",
    ["alt+6"]                = "root:switch-to-tab-6",
    ["alt+7"]                = "root:switch-to-tab-7",
    ["alt+8"]                = "root:switch-to-tab-8",
    ["alt+9"]                = "root:switch-to-tab-9",
    ["ctrl+f"]               = "find-replace:find",
    ["ctrl+r"]               = "find-replace:replace",
    ["f3"]                   = "find-replace:repeat-find",
    ["shift+f3"]             = "find-replace:previous-find",
    ["ctrl+i"]               = "find-replace:toggle-sensitivity",
    ["ctrl+shift+i"]         = "find-replace:toggle-regex",
    ["ctrl+shift+space"]     = "doc:align-carets",
    ["ctrl+shift+l"]         = "doc:left-align-selections",
    ["ctrl+shift+r"]         = "doc:right-align-selections",
    ["ctrl+g"]               = "doc:go-to-line",
    ["ctrl+s"]               = "doc:save",
    ["ctrl+shift+s"]         = "doc:save-as",
    ["ctrl+z"]               = "doc:undo",
    ["ctrl+y"]               = "doc:redo",
    ["ctrl+x"]               = "doc:cut",
    ["ctrl+c"]               = "doc:copy",
    ["ctrl+v"]               = "doc:paste",
    ["shift+tab"]            = "doc:unindent",
    ["backspace"]            = "doc:backspace",
    ["ctrl+backspace"]       = "doc:delete-to-previous-word-start",
    ["delete"]               = "doc:delete",
    ["ctrl+delete"]          = "doc:delete-to-next-word-end",
    ["ctrl+return"]          = "doc:newline-below",
    ["ctrl+shift+return"]    = "doc:newline-above",
    ["ctrl+j"]               = "doc:join-lines",
    ["ctrl+a"]               = "doc:select-all",
    ["ctrl+l"]               = "doc:select-lines",
    ["ctrl+escape"]          = "doc:toggle-line-comments",
    ["ctrl+shift+d"]         = "doc:duplicate-lines",
    ["ctrl+shift+k"]         = "doc:delete-lines",
    ["ctrl+up"]              = "doc:move-lines-up",
    ["ctrl+down"]            = "doc:move-lines-down",
    ["ctrl+left"]            = "doc:move-to-previous-word-start",
    ["ctrl+right"]           = "doc:move-to-next-word-end",
    ["ctrl+["]               = "doc:move-to-previous-block-start",
    ["ctrl+]"]               = "doc:move-to-next-block-end",
    ["home"]                 = "doc:move-to-start-of-indentation",
    ["end"]                  = "doc:move-to-end-of-line",
    ["ctrl+home"]            = "doc:move-to-start-of-doc",
    ["ctrl+end"]             = "doc:move-to-end-of-doc",
    ["pageup"]               = "doc:move-to-previous-page",
    ["pagedown"]             = "doc:move-to-next-page",
    ["shift+left"]           = "doc:select-to-previous-char",
    ["shift+right"]          = "doc:select-to-next-char",
    ["shift+up"]             = "doc:select-to-previous-line",
    ["shift+down"]           = "doc:select-to-next-line",
    ["alt+shift+left"]       = "doc:select-to-previous-word-start",
    ["alt+shift+right"]      = "doc:select-to-next-word-end",
    ["ctrl+shift+["]         = "doc:select-to-previous-block-start",
    ["ctrl+shift+]"]         = "doc:select-to-next-block-end",
    ["shift+home"]           = "doc:select-to-start-of-indentation",
    ["shift+end"]            = "doc:select-to-end-of-line",
    ["ctrl+shift+end"]       = "doc:select-to-end-of-doc",
    ["shift+pageup"]         = "doc:select-to-previous-page",
    ["shift+pagedown"]       = "doc:select-to-next-page",
    ["ctrl+shift+up"]        = "doc:create-cursor-previous-line",
    ["ctrl+shift+down"]      = "doc:create-cursor-next-line",
    ["f7"]                   = { "exterm:open-terminal" },
    ["shift+delete"]         = { "minimap:toggle-visibility" },
    ["ctrl+shift+home"]      = { "minimap:toggle-syntax-highlighting" },
    ["escape"]               = { "command:escape", "doc:select-none", "dialog:select-no" },
    ["tab"]                  = { "command:complete", "doc:indent" },
    ["return"]               = { "command:submit", "doc:newline", "dialog:select" },
    ["keypad enter"]         = { "command:submit", "doc:newline", "dialog:select" },
    ["ctrl+d"]               = { "find-replace:select-next", "doc:select-word" },
    ["left"]                 = { "doc:move-to-previous-char", "dialog:previous-entry" },
    ["right"]                = { "doc:move-to-next-char", "dialog:next-entry"},
    ["up"]                   = { "command:select-previous", "doc:move-to-previous-line" },
    ["down"]                 = { "command:select-next", "doc:move-to-next-line" },
}

-- pass 'true' for second parameter to overwrite an existing binding
-- keymap.add({ ["ctrl+pageup"] = "root:switch-to-previous-tab" }, true)
-- keymap.add({ ["ctrl+pagedown"] = "root:switch-to-next-tab" }, true)
-- Propo-SemiBold
------------------------------- Fonts ----------------------------------------

-- customize fonts:Medium
style.font = renderer.font.load("/usr/share/fonts/TTF/FiraCode-Regular.ttf", 15 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/JetBrainsMono-Regular.ttf", 18 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/IBMPlexMono-Regular.ttf", 18 * SCALE)
style.code_font = renderer.font.load("/usr/share/fonts/TTF/VictorMonoNerdFont-Medium.ttf", 18 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/MonoidNerdFontMono-Regular.ttf", 16 * SCALE)
-- style.code_font = renderer.font.load("/usr/share/fonts/TTF/FiraCode-Regular.ttf", 18 * SCALE)
-- 'IBM Plex Mono' Medium (vscode font)
-- DATADIR is the location of the installed Lite XL Lua code, default color
-- schemes and fonts.
-- USERDIR is the location of the Lite XL configuration directory.
--
-- font names used by lite:
-- style.font          : user interface
-- style.big_font      : big text in welcome screen
-- style.icon_font     : icons
-- style.icon_big_font : toolbar icons
-- style.code_font     : code
--
-- the function to load the font accept a 3rd optional argument like:
--
-- {antialiasing="grayscale", hinting="full", bold=true, italic=true, underline=true, smoothing=true, strikethrough=true}
--
-- possible values are:
-- antialiasing: grayscale, subpixel
-- hinting: none, slight, full
-- bold: true, false
-- italic: true, false
-- underline: true, false
-- smoothing: true, false
-- strikethrough: true, false

------------------------------ Plugins ----------------------------------------

-- enable or disable plugin loading setting config entries:

-- enable plugins.trimwhitespace, otherwise it is disabled by default:
-- config.plugins.trimwhitespace = true
--
-- disable detectindent, otherwise it is enabled by default
-- config.plugins.detectindent = false

---------------------------- Miscellaneous -------------------------------------

-- modify list of files to ignore when indexing the project:
-- config.ignore_files = {
--   -- folders
--   "^%.svn/",        "^%.git/",   "^%.hg/",        "^CVS/", "^%.Trash/", "^%.Trash%-.*/",
--   "^node_modules/", "^%.cache/", "^__pycache__/",
--   -- files
--   "%.pyc$",         "%.pyo$",       "%.exe$",        "%.dll$",   "%.obj$", "%.o$",
--   "%.a$",           "%.lib$",       "%.so$",         "%.dylib$", "%.ncb$", "%.sdf$",
--   "%.suo$",         "%.pdb$",       "%.idb$",        "%.class$", "%.psd$", "%.db$",
--   "^desktop%.ini$", "^%.DS_Store$", "^%.directory$",
-- }
