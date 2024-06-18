-- monochrome-lite

local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#b7b6b5" } -- editor
style.background2 = { common.color "#383e40" } -- treeview, other tabs
style.background3 = { common.color "#596366" } -- menus
style.text = { common.color "#888888" }
style.caret = { common.color "#1d2021" }
style.accent = { common.color "#1d2021" } -- Text in autocomplete and command, col(>80) in satusbar
style.dim = { common.color "#888888" } -- Text of nonactive tabs, prefix in log
style.divider = { common.color "#151515" }
style.selection = { common.color "#596366" }
style.line_number = { common.color "#3b3b3b" }
style.line_number2 = { common.color "#888888" } -- Number on line with caret
style.line_highlight = { common.color "#a1a1a1"}
style.scrollbar = { common.color "#2e2e2e" }
style.scrollbar2 = { common.color "#3b3b3b" } -- Hovered

style.syntax["normal"] = { common.color "#1d2021" }
style.syntax["symbol"] = { common.color "#1d2021" }
style.syntax["comment"] = { common.color "#859499" }
style.syntax["keyword"] = { common.color "#1d2021" }  -- local function end, if case
style.syntax["keyword2"] = { common.color "#1d2021" } -- self, int float
style.syntax["number"] = { common.color "#1d2021" }
style.syntax["literal"] = { common.color "#1d2021" }
style.syntax["string"] = { common.color "#1d2021" }
style.syntax["string2"] = { common.color "#1d2021" }
style.syntax["string3"] = { common.color "#1d2021" }
style.syntax["operator"] = { common.color "#1d2021"}  -- = + - / < >
style.syntax["function"] = { common.color "#1d2021" }

-- PLUGINS
style.linter_warning = { common.color "#d8ad4c" }     -- linter
style.bracketmatch_color = { common.color "#d245a9" } -- bracketmatch underline color
style.guide = { common.color "#b6b6b6" }              -- indentguide
style.guide_highlight = { common.color "#2e2e2e" }    -- indentguide
style.guide_width = 1                                 -- indentguide
style.bracketmatch_char_color = { common.color "#1d2021" } -- bracket color 
style.bracketmatch_block_color = { common.color "#1d2021" } -- background color
style.bracketmatch_frame_color = { common.color "#1d2021" } -- frame color
style.syntax.paren_unbalanced = style.syntax.paren_unbalanced or { common.color "#1d2021" }
style.syntax.paren1 = style.syntax.paren1 or { common.color "#1d2021"}
style.syntax.paren2 = style.syntax.paren2 or { common.color "#1d2021"}
style.syntax.paren3 = style.syntax.paren3 or { common.color "#1d2021"}
style.syntax.paren4 = style.syntax.paren4 or { common.color "#1d2021"}
style.syntax.paren5 = style.syntax.paren5 or { common.color "#1d2021"}
