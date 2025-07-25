local style = require "core.style"
local common = require "core.common"

-- UI COLORS
style.background             = { common.color "#1E1F29" }
style.background2            = { common.color "#282a36" }
style.background3            = { common.color "#21222b" }
style.text                   = { common.color "#7b81a6" }
style.caret                  = { common.color "#f8f8f0" }
style.accent                 = { common.color "#8be9fd" }
style.dim                    = { common.color "#4f5873" }
style.divider                = { common.color "#1f2029" }
style.selection              = { common.color "#44475a" }
style.line_number            = { common.color "#53576e" }
style.line_number2           = { common.color "#5ECD3F" }
style.line_highlight         = { common.color "#313442" }
style.scrollbar              = { common.color "#44475a" }
style.scrollbar2             = { common.color "#ff79c6" }
style.guide                  = { common.color "#343A4D" } -- indentguide

-- CODE COLORS
style.syntax["normal"]       = { common.color "#A39A90" }
style.syntax["symbol"]       = { common.color "#6F8BA6" }
style.syntax["comment"]      = { common.color "#576D82" }
style.syntax["keyword"]      = { common.color "#5AF78E" }
style.syntax["keyword2"]     = { common.color "#E6E6E6" }
style.syntax["number"]       = { common.color "#DD7C19" }
style.syntax["literal"]      = { common.color "#FF5555" }
style.syntax["string"]       = { common.color "#BD93F9" }
style.syntax["string2"]      = { common.color "#CAA9FA" }
style.syntax["operator"]     = { common.color "#057085" }
style.syntax["function"]     = { common.color "#CA294D" }
style.syntax["preprocessor"] = { common.color "#50FA7B" } -- thinking ahead
