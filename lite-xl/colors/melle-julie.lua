-- melle julie

local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#1c1f24" }
style.background2 = { common.color "#171a1e" }
style.background3 = { common.color "#171a1e" }
style.text = { common.color "#b3b3b3" }
style.caret = { common.color "#ffffff" }
style.accent = { common.color "#bf9559" }       -- Text in autocomplete and command, col(>80) in satusbar
style.dim = { common.color "#565f89" }          -- Text of nonactive tabs, prefix in log
style.divider = { common.color "#24283b" }
style.selection = { common.color "#414868" }
style.line_number = { common.color "#3c3836" }
style.line_number2 = { common.color "#bdae93" } -- Number on line with caret
style.line_highlight = { common.color "#1c1f24"}
style.scrollbar = { common.color "#24283b" }
style.scrollbar2 = { common.color "#414868" }   -- Hovered

style.syntax["normal"] = { common.color "#bdae93" }
style.syntax["symbol"] = { common.color "#5798b3" }
style.syntax["comment"] = { common.color "#928374" }
style.syntax["keyword"] = { common.color "#daaf5c" }  -- local function end, if case
style.syntax["keyword2"] = { common.color "#daaf5c" } -- self, int float
style.syntax["number"] = { common.color "#8f3f71" }
style.syntax["literal"] = { common.color "#5798b3" }
style.syntax["string"] = { common.color "#b3b3b3" }
style.syntax["string2"] = { common.color "#69e18f" }
style.syntax["string3"] = { common.color "#69e18f" }
style.syntax["operator"] = { common.color "#cc241d"}  -- = + - / < >
style.syntax["function"] = { common.color "#5798b3" }

-- PLUGINS
style.linter_warning = { common.color "#bf9559" }     -- linter
style.bracketmatch_color = { common.color "#565f89" } -- bracketmatch
style.guide = { common.color "#7c6f6440" }            -- indentguide
style.guide_highlight = { common.color "#bf9559" }    -- indentguide
style.guide_width = 1                                   -- indentguide
