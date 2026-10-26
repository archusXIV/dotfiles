-- vim-like by archusXIV <https://github.com/archusXIV>

local common    = require "core.common"
local config    = require "core.config"         -- needed for highlight_current_line
config.highlight_current_line = "no_selection"  -- while selecting do not use line.highlight
local style     = require "core.style"

local accent    = { common.color "#18a0d2" }
local bg1       = { common.color "#000000" }
local bg2       = { common.color "#111111" }
local dim       = { common.color "#596366" }
local divider   = { common.color "#222222" }
local keyword   = { common.color "#a4771a" }
local operator  = { common.color "#b33891" }
local selection = { common.color "#003e8c" }
local string    = { common.color "#bd1804" }
local string2   = { common.color "#bf4505" }
local white     = { common.color "#ffffff" }

-- GUI COLORS
style.background         = bg1                 -- editor background
style.background2        = bg2                 -- treeview, other tabs
style.background3        = bg2                 -- menus
style.text               = white
style.caret              = white
style.accent             = accent              -- text in autocomplete and command, col(>80) in satusbar
style.dim                = dim                 -- text of nonactive tabs, prefix in log
style.divider            = divider             -- boundaries between bg, bg2
style.guide              = bg1                 -- indentguide
style.guide_highlight    = divider             -- indentguide
style.guide_width        = 1                   -- indentguide
style.line_number        = divider             -- no comment
style.line_number2       = accent              -- number on the curent line
style.line_highlight     = bg1                 -- no comment
style.selection          = selection           -- selected word/line
style.scrollbar          = bg2                 -- no comment
style.scrollbar2         = selection           -- hovered scrollbar

-- CODE COLORS
style.syntax["normal"]   = white
style.syntax["symbol"]   = white
style.syntax["comment"]  = dim                 -- no comment
style.syntax["keyword"]  = keyword             -- if, while, for, end, etc...
style.syntax["keyword2"] = string2
style.syntax["number"]   = accent
style.syntax["literal"]  = selection
style.syntax["string"]   = string
style.syntax["string2"]  = string2
style.syntax["string3"]  = string2
style.syntax["operator"] = operator            -- = + - / < >
style.syntax["function"] = operator            -- my_command --something

-- PLUGINS (make sure those are installed)
style.bracketmatch_color = accent
style.syntax.paren_unbalanced = style.syntax.paren_unbalanced or white
style.syntax.paren1 = style.syntax.paren1 or string
style.syntax.paren2 = style.syntax.paren2 or string2
style.syntax.paren3 = style.syntax.paren3 or keyword
style.syntax.paren5 = style.syntax.paren4 or selection
style.syntax.paren4 = style.syntax.paren5 or operator

