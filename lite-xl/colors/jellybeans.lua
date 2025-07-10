-- Colors from: https://github.com/nanotech/jellybeans.vim

local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#151515" }
style.background2 = { common.color "#212121" }
style.background3 = { common.color "#212121" }
style.text = { common.color "#e8e8d3" }
style.caret = { common.color "#e8e8d3" }
style.accent = { common.color "#597bc5" } -- Text in autocomplete and command, col(>80) in satusbar
style.dim = { common.color "#888888" } -- Text of nonactive tabs, prefix in log
style.divider = { common.color "#151515" }
style.selection = { common.color "#2e2e2e" }
style.line_number = { common.color "#3b3b3b" }
style.line_number2 = { common.color "#888888" } -- Number on line with caret
style.line_highlight = { common.color "#1a1a1a"}
style.scrollbar = { common.color "#2e2e2e" }
style.scrollbar2 = { common.color "#3b3b3b" } -- Hovered

style.syntax["normal"] = { common.color "#6b8b9b" }
style.syntax["symbol"] = { common.color "#ccccba" }
style.syntax["comment"] = { common.color "#888888" }
style.syntax["keyword"] = { common.color "#b267e6" }  -- local function end, if case
style.syntax["keyword2"] = { common.color "#8197BF" } -- self, int float
style.syntax["number"] = { common.color "#cf6a4c" }
style.syntax["literal"] = { common.color "#8FBFDC" }
style.syntax["string"] = { common.color "#99ad6a" }
style.syntax["string3"] = { common.color "#a3b394" }
style.syntax["operator"] = { common.color "#597bc5"}  -- = + - / < >
style.syntax["function"] = { common.color "#b267e6" }

-- PLUGINS
style.linter_warning = { common.color "#d8ad4c" }     -- linter
style.bracketmatch_color = { common.color "#8197bf" } -- bracketmatch
style.guide = { common.color "#212121" }              -- indentguide
style.guide_highlight = { common.color "#2e2e2e" }    -- indentguide
style.guide_width = 1                                 -- indentguide

