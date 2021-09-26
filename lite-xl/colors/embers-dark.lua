-- Most of the colors are taken from:
-- https://github.com/microsoft/vscode/tree/master/extensions/theme-defaults/themes

local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#1E1F29" }
style.background2 = { common.color "#282a36" }
style.background3 = { common.color "#1E1F29" }
style.text = { common.color "#7b81a6" }
style.caret = { common.color "#FFFFFF" }
style.accent = { common.color "#F2C759" } -- Text in autocomplete and command, col(>80) in satusbar
style.dim = { common.color "#7A7A7A" } -- Text of nonactive tabs, prefix in log
style.divider = { common.color "#1E1E1E" }
style.selection = { common.color "#264F78" }
style.line_number = { common.color "#707070" }
style.line_number2 = { common.color "#F2C759" } -- Number on line with caret
style.line_highlight = { common.color "#333A40"}
style.scrollbar = { common.color "#404040" }
style.scrollbar2 = { common.color "#707070" } -- Hovered

style.syntax["normal"] = { common.color "#a39a90" }
style.syntax["symbol"] = { common.color "#9A8F74" }
style.syntax["comment"] = { common.color "#5c6370" }
style.syntax["keyword"] = { common.color "#7b81a6" }  -- local function end, if case
style.syntax["keyword2"] = { common.color "#C586C0" } -- self, int float
style.syntax["number"] = { common.color "#57826d" }
style.syntax["literal"] = { common.color "#8be9fd" }
style.syntax["string"] = { common.color "#82576d" }
style.syntax["string2"] = { common.color "#6d5782" }
style.syntax["string3"] = { common.color "#5ECD3F" }
style.syntax["operator"] = { common.color "#cc6666"}  -- = + - / < > [ (
style.syntax["function"] = { common.color "#DCDCAA" }

-- PLUGINS
style.linter_warning = { common.color "#B89500" }     -- linter
style.bracketmatch_color = { common.color "#DB23A5" } -- bracketmatch
style.guide = { common.color "#333333" }              -- indentguide
style.guide_width = 1                                 -- indentguide
