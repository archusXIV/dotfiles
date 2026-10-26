-- GmnFrost by archusXIV <https://github.com/archusXIV>

local style = require "core.style"
local common = require "core.common"
local white = { common.color "#9BBBC6" }

-- GUI COLORS
style.background         = { common.color "#1C1C23" } -- editor
style.background2        = { common.color "#323246" } -- treeview, other tabs
style.background3        = { common.color "#323246" } -- menus
style.text               = white
style.caret              = { common.color "#e8e8d3" }
style.accent             = { common.color "#6EA0B4" } -- Text in autocomplete and command, col(>80) in satusbar
style.dim                = { common.color "#5A7882" } -- Text of nonactive tabs, prefix in log
style.divider            = { common.color "#323246" }
style.guide              = { common.color "#212121" } -- indentguide
style.guide_highlight    = { common.color "#2e2e2e" } -- indentguide
style.guide_width        = 1                          -- indentguide
style.line_number        = { common.color "#3b3b3b" }
style.line_number2       = { common.color "#888888" } -- Number on line with caret
style.line_highlight     = { common.color "#323246" }
style.selection          = { common.color "#262626" }
style.scrollbar          = { common.color "#262626" }
style.scrollbar2         = { common.color "#3b3b3b" } -- Hovered

-- SYNTAX COLORS
style.syntax["normal"]   = white
style.syntax["symbol"]   = white
style.syntax["comment"]  = { common.color "#888888" }
style.syntax["keyword"]  = { common.color "#3C788C" }
style.syntax["keyword2"] = { common.color "#5A7882" }
style.syntax["number"]   = white
style.syntax["literal"]  = white
style.syntax["string"]   = white
style.syntax["string2"]  = white
style.syntax["string3"]  = white
style.syntax["operator"] = white  -- = + - / < >
style.syntax["function"] = white

-- PLUGINS
style.bracketmatch_color = { common.color "#6EA0B4" }
style.syntax.paren_unbalanced = style.syntax.paren_unbalanced or white
style.syntax.paren1 = style.syntax.paren1 or white
style.syntax.paren2 = style.syntax.paren2 or white
style.syntax.paren3 = style.syntax.paren3 or white
style.syntax.paren4 = style.syntax.paren4 or white
style.syntax.paren5 = style.syntax.paren5 or white

