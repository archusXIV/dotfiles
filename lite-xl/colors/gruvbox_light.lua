-- gruvbox-light

local style = require "core.style"
local common = require "core.common"

-- UI COLORS
style.background         = { common.color "#ebdbb2" }
style.background2        = { common.color "#bdae93" }
style.background3        = { common.color "#bdae93" }
style.text               = { common.color "#565f89" }
style.caret              = { common.color "#b57614" }
style.accent             = { common.color "#24283b" }   -- Selected text in autocomplete and command, col(>80) in satusbar
style.dim                = { common.color "#24283b" }   -- Text of nonactive tabs, prefix in log
style.divider            = { common.color "#24283b" }
style.selection          = { common.color "#689d6a69" }
style.line_number        = { common.color "#bdae93" }
style.line_number2       = { common.color "#3c3836" }   -- Number on line with caret
style.line_highlight     = { common.color "#d5c4a1" }
style.scrollbar          = { common.color "#24283b" }
style.scrollbar2         = { common.color "#414868" }   -- Hovered

-- CODE COLORS
style.syntax["normal"]   = { common.color "#3c3836" }
style.syntax["symbol"]   = { common.color "#24283b" }
style.syntax["comment"]  = { common.color "#928374" }
style.syntax["keyword"]  = { common.color "#9d0006" }   -- local function end, if case
style.syntax["keyword2"] = { common.color "#458588" }   -- self, int float
style.syntax["number"]   = { common.color "#272727" }
style.syntax["literal"]  = { common.color "#79740e" }
style.syntax["string"]   = { common.color "#076678" }
style.syntax["string2"]  = { common.color "#076678" }
style.syntax["string3"]  = { common.color "#076678" }
style.syntax["operator"] = { common.color "#9d0006" }   -- = + - / < >
style.syntax["function"] = { common.color "#b57614" }

-- PLUGINS
style.bracketmatch_color = { common.color "#af3a03" }   -- bracketmatch
style.guide              = { common.color "#d5c4a1" }   -- indentguide
style.guide_highlight    = { common.color "#bf9559" }   -- indentguide
style.guide_width        = 1                                -- indentguide
