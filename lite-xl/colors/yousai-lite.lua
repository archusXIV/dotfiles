-- yousai

local style = require "core.style"
local common = require "core.common"

-- UI COLORS
style.background         = { common.color "#f5e7de" }
style.background2        = { common.color "#d1c6bb" }
style.background3        = { common.color "#d1c6bb" }
style.text               = { common.color "#7e776f" }
style.caret              = { common.color "#a67c53" }
style.accent             = { common.color "#4c4742" }   -- Selected text in autocomplete and command, col(>80) in satusbar
style.dim                = { common.color "#4c4742" }   -- Text of nonactive tabs, prefix in log
style.divider            = { common.color "#4c4742" }
style.selection          = { common.color "#f2854a89" }
style.line_number        = { common.color "#bdae93" }
style.line_number2       = { common.color "#3c3836" }   -- Number on line with caret
style.line_highlight     = { common.color "#dfd3c5" }
style.scrollbar          = { common.color "#34302d" }
style.scrollbar2         = { common.color "#4c7399" }   -- Hovered

-- CODE COLORS
style.syntax["normal"]   = { common.color "#3c3836" }
style.syntax["symbol"]   = { common.color "#24283b" }
style.syntax["comment"]  = { common.color "#7f7f7a" }
style.syntax["keyword"]  = { common.color "#b23636" }   -- local function end, if case
style.syntax["keyword2"] = { common.color "#992e2e" }   -- self, int float
style.syntax["number"]   = { common.color "#f2854a" }
style.syntax["literal"]  = { common.color "#a67c53" }
style.syntax["string"]   = { common.color "#664233" }
style.syntax["string2"]  = { common.color "#664233" }
style.syntax["string3"]  = { common.color "#5986b2" }
style.syntax["operator"] = { common.color "#9d0006" }   -- = + - / < >
style.syntax["function"] = { common.color "#bf8f60" }

-- PLUGINS
style.bracketmatch_color = { common.color "#af3a03" }   -- bracketmatch
style.guide              = { common.color "#dfd3c5" }   -- indentguide
style.guide_highlight    = { common.color "#bf9559" }   -- indentguide
style.guide_width        = 1                                -- indentguide
