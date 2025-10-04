-- github style

local style = require "core.style"
local common = require "core.common"

-- UI COLORS
style.background         = { common.color "#fbfbfb" }
style.background2        = { common.color "#262b40" }
style.background3        = { common.color "#262b40" }
style.text               = { common.color "#adbac7" }
style.caret              = { common.color "#181818" }
style.accent             = { common.color "#0366d6" }
style.dim                = { common.color "#b0b0b0" }
style.divider            = { common.color "#e8e8e8" }
style.selection          = { common.color "#b7dce8" }
style.line_number        = { common.color "#d0d0d0" }
style.line_number2       = { common.color "#808080" }
style.line_highlight     = { common.color "#f2f2f2" }
style.scrollbar          = { common.color "#e0e0e0" }
style.scrollbar2         = { common.color "#c0c0c0" }

-- CODE COLORS
style.syntax["normal"]   = { common.color "#24292e" }
style.syntax["symbol"]   = { common.color "#24292e" }
style.syntax["comment"]  = { common.color "#6a737d" }
style.syntax["keyword"]  = { common.color "#d73a49" }
style.syntax["keyword2"] = { common.color "#d73a49" }
style.syntax["number"]   = { common.color "#005cc5" }
style.syntax["literal"]  = { common.color "#005cc5" }
style.syntax["string"]   = { common.color "#032f62" }
style.syntax["string2"]  = { common.color "#032F62" }
style.syntax["operator"] = { common.color "#d73a49" }
style.syntax["function"] = { common.color "#005cc5" }
