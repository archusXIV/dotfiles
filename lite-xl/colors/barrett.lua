--Description: My personal easy on eyes colorscheme.

local style = require "core.style"
local common = require "core.common"

-- Editor gui
style.background = { common.color "#1A1B24" }        -- Editor main window
style.background2 = { common.color "#262840" }       -- Inactive tabs an treeview
style.background3 = { common.color "#1A1B24" }       -- Active tab
style.text = { common.color "#7b81a6" }
style.caret = { common.color "#FFFFFF" }
style.accent = { common.color "#8be9fd" }            -- Text in autocomplete and command, col(>80) in satusbar
style.dim = { common.color "#707070" }               -- Text of nonactive tabs, prefix in log
style.divider = { common.color "#1E1E1E" }
style.selection = { common.color "#264F78" }
style.line_number = { common.color "#707070" }
style.line_number2 = { common.color "#5ECD3F" }      -- Number on line with caret
style.line_highlight = { common.color "#252633"}
style.scrollbar = { common.color "#404040" }
style.scrollbar2 = { common.color "#707070" }        -- Hovered

-- Code syntax
style.syntax["normal"] = { common.color "#96736E" }
style.syntax["symbol"] = { common.color "#7A8C99" }
style.syntax["comment"] = { common.color "#464A52" }
style.syntax["keyword"] = { common.color "#AF5EA0" }  -- local function end, if case
style.syntax["keyword2"] = { common.color "#AB7967" } -- self, int float
style.syntax["number"] = { common.color "#D43838" }
style.syntax["literal"] = { common.color "#8be9fd" }
style.syntax["string"] = { common.color "#899178" }
style.syntax["string2"] = { common.color "#D08770" }
style.syntax["string3"] = { common.color "#A0CC7A" }
style.syntax["operator"] = { common.color "#424D9A"}  -- = + - / < >
style.syntax["function"] = { common.color "#948988" }

-- PLUGINS
style.linter_warning = { common.color "#B89500" }     -- linter
style.bracketmatch_color = { common.color "#66CEAD" } -- bracketmatch
style.guide = { common.color "#262626" }              -- indentguide
style.guide_width = 1                                 -- indentguide
