-- monochrome-dark

local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#1d2021" } -- editor
style.background2 = { common.color "#383e40" } -- treeview, other tabs
style.background3 = { common.color "#596366" } -- menus
style.text = { common.color "#e8e8d3" }
style.caret = { common.color "#e8e8d3" }
style.accent = { common.color "#597bc5" } -- Text in autocomplete and command, col(>80) in satusbar
style.dim = { common.color "#888888" } -- Text of nonactive tabs, prefix in log
style.divider = { common.color "#151515" }
style.selection = { common.color "#2e2e2e" }
style.line_number = { common.color "#3b3b3b" }
style.line_number2 = { common.color "#888888" } -- Number on line with caret
style.line_highlight = { common.color "#191919"}
style.scrollbar = { common.color "#2e2e2e" }
style.scrollbar2 = { common.color "#3b3b3b" } -- Hovered

style.syntax["normal"] = { common.color "#b6b6b6" }
style.syntax["symbol"] = { common.color "#b6b6b6" }
style.syntax["comment"] = { common.color "#888888" }
style.syntax["keyword"] = { common.color "#b6b6b6" }  -- local function end, if case
style.syntax["keyword2"] = { common.color "#b6b6b6" } -- self, int float
style.syntax["number"] = { common.color "#b6b6b6" }
style.syntax["literal"] = { common.color "#b6b6b6" }
style.syntax["string"] = { common.color "#b6b6b6" }
style.syntax["string2"] = { common.color "#b6b6b6" }
style.syntax["string3"] = { common.color "#b6b6b6" }
style.syntax["operator"] = { common.color "#b6b6b6"}  -- = + - / < >
style.syntax["function"] = { common.color "#b6b6b6" }

-- PLUGINS
style.linter_warning = { common.color "#d8ad4c" }     -- linter
style.bracketmatch_color = { common.color "#8197bf" } -- bracketmatch
style.guide = { common.color "#212121" }              -- indentguide
style.guide_highlight = { common.color "#2e2e2e" }    -- indentguide
style.guide_width = 1                                 -- indentguide
style.syntax.paren_unbalanced = style.syntax.paren_unbalanced or { common.color "#b6b6b6" }
style.syntax.paren1  =  style.syntax.paren1 or { common.color "#b6b6b6"}
style.syntax.paren2  =  style.syntax.paren2 or { common.color "#b6b6b6"}
style.syntax.paren3  =  style.syntax.paren3 or { common.color "#b6b6b6"}
style.syntax.paren4  =  style.syntax.paren4 or { common.color "#b6b6b6"}
style.syntax.paren5  =  style.syntax.paren5 or { common.color "#b6b6b6"}

