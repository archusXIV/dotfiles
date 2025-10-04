-- embers-dark

local style = require "core.style"
local common = require "core.common"

-- UI COLORS
style.background         = { common.color "#1E1F29" } -- 1E1F29
style.background2        = { common.color "#252633" }
style.background3        = { common.color "#1E1F29" }
style.text               = { common.color "#576d82" }
style.caret              = { common.color "#dbd6d1" }
style.accent             = { common.color "#998C82" } -- Text in autocomplete and command, col(>80) in satusbar
style.dim                = { common.color "#576d82" } -- Text of nonactive tabs, prefix in log
style.divider            = { common.color "#16130f" }
style.selection          = { common.color "#264F78" }
style.line_number        = { common.color "#707070" }
style.line_number2       = { common.color "#cc6677" } -- Number on line with caret
style.line_highlight     = { common.color "#252633" }
style.scrollbar          = { common.color "#5a5047" }
style.scrollbar2         = { common.color "#826d57" } -- Hovered
style.scrollbar_size     = common.round(8 * SCALE)

-- CODE COLORS
style.syntax["normal"]   = { common.color "#998C82" }
style.syntax["symbol"]   = { common.color "#9A8F74" }
style.syntax["comment"]  = { common.color "#5c6370" }
style.syntax["keyword"]  = { common.color "#6d5782" } -- local function end, if case loops
style.syntax["keyword2"] = { common.color "#A66F8B" } -- self, int float
style.syntax["number"]   = { common.color "#57826d" }
style.syntax["literal"]  = { common.color "#a39a90" }
style.syntax["string"]   = { common.color "#576d82" }
style.syntax["string2"]  = { common.color "#6d5782" }
style.syntax["string3"]  = { common.color "#57826d" }
style.syntax["operator"] = { common.color "#cc6677" } -- = < > [ ( && ||
style.syntax["function"] = { common.color "#787D57" }

-- PLUGINS
style.bracketmatch_color = { common.color "#cc6677" } -- bracketmatch underline
style.guide              = { common.color "#252633" } -- indentguide
style.guide_width        = 1                          -- indentguide

