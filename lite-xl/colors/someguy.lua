local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#1E1F29" }
style.background2 = { common.color "#252633" } -- 1E1F29
style.background3 = { common.color "#52546B" }
style.text = { common.color "#7b81a6" }
style.caret = { common.color "#f8f8f0" }
style.accent = { common.color "#8be9fd" } -- Text in autocomplete and command, col(>80) in satusbar
style.dim = { common.color "#4f5873" } -- Text of nonactive tabs, prefix in log
style.divider = { common.color "#1f2029" }
style.selection = { common.color "#44475a" }
style.line_number = { common.color "#53576e" }
style.line_number2 = { common.color "#82AEEF" } -- Number on line with caret
style.line_highlight = { common.color "#1E1F29" }
style.scrollbar = { common.color "#44475a" }
style.scrollbar2 = { common.color "#3060A6" } -- Hovered
style.scrollbar_size = common.round(8 * SCALE)
style.guide = { common.color "#22242E" } -- indentguide

style.syntax["normal"] = { common.color "#8EA4C6" }
style.syntax["symbol"] = { common.color "#4578C6" }
style.syntax["comment"] = { common.color "#5c6370" }
style.syntax["keyword"] = { common.color "#5CACBD" } -- local function end, if case loops
style.syntax["keyword2"] = { common.color "#009FF0" } -- self, int float
style.syntax["number"] = { common.color "#82AEEF" }
style.syntax["literal"] = { common.color "#8be9fd" }
style.syntax["string"] = { common.color "#94BD97" }
style.syntax["string2"] = { common.color "#2D6566" }
style.syntax["string3"] = { common.color "#413CA8" }
style.syntax["operator"] = { common.color "#567C72" } -- = + - / < > [ ( && || [[ ]]
style.syntax["function"] = { common.color "#8970BF" }
style.syntax["preprocessor"] = { common.color "##7672E8" } -- thinking ahead
