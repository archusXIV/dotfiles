-- Author Barret E <archus@protonmail.com>
-- https://github.com/archusXIV
local style = require "core.style"
local common = require "core.common"
-- gui colors
style.background = { common.color "#252940" }
style.background2 = { common.color "#1E1F29" }
style.background3 = { common.color "#35393B" }
style.text = { common.color "#7b81a6" }
style.caret = { common.color "#f8f8f0" }
style.accent = { common.color "#A06D4E" } -- Text in autocomplete and command, col(>80) in satusbar
style.dim = { common.color "#4f5873" } -- Text of nonactive tabs, prefix in log
style.divider = { common.color "#1f2029" }
style.selection = { common.color "#53576e" }
style.line_number = { common.color "#53576e" }
style.line_number2 = { common.color "#82AEEF" } -- Number on line with caret
style.line_highlight = { common.color "#1E1F29" }
style.scrollbar = { common.color "#44475a" }
style.scrollbar2 = { common.color "#3060A6" } -- Hovered
style.scrollbar_size = common.round(8 * SCALE)
style.guide = { common.color "#252940" } -- indentguide
style.guide_highlight = { common.color "#8454c0" }    -- indentguide
style.guide_width = 1                                 -- indentguide
-- code colors
style.syntax["normal"] = { common.color "#817C5C" }
style.syntax["symbol"] = { common.color "#82AEEF" }
style.syntax["comment"] = { common.color "#3a4166" }
style.syntax["keyword"] = { common.color "#8454D1" } -- local function end, if case loops
style.syntax["keyword2"] = { common.color "#AF92E6" } -- self, int float
style.syntax["number"] = { common.color "#82AEEF" }
style.syntax["literal"] = { common.color "#5b99a6" }
style.syntax["string"] = { common.color "#9391A6" }
style.syntax["string2"] = { common.color "#817C5C" }
style.syntax["string3"] = { common.color "#6AA1F2" }
style.syntax["operator"] = { common.color "#A06D4E" } -- = + - / < > [ ( && || [[ ]]
style.syntax["function"] = { common.color "#8970BF" }
style.syntax["preprocessor"] = { common.color "#7672E8" } -- thinking ahead
