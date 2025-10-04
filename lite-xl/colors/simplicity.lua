-- simplicity colorscheme for lite-xl, Author: Barret E <archus@protonmail>
local style = require "core.style"
local common = require "core.common"

-- UI COLORS
style.background         = { common.color "#272836" }
style.background2        = { common.color "#1D1E29" }
style.background3        = { common.color "#1D1E29" }
style.text               = { common.color "#778899" }
style.caret              = { common.color "#cccccc" }
style.accent             = { common.color "#D7BD8A" }
style.dim                = { common.color "#778899" }
style.divider            = { common.color "#1e232b" }
style.selection          = { common.color "#2c3440" }
style.guide              = { common.color "#2c3440" }
style.line_number        = { common.color "#778899" }
style.line_number2       = { common.color "#D7BD8A" }
style.line_highlight     = { common.color "#272836" }
style.scrollbar          = { common.color "#2c3440" }
style.scrollbar2         = { common.color "#97B19C" }
style.scrollbar_track    = { common.color "#00000000" }
style.nagbar             = { common.color "#BF5C56" }
style.nagbar_text        = { common.color "#cccccc" }
style.nagbar_dim         = { common.color "rgba(0, 0, 0, 0.45)" }
style.drag_overlay       = { common.color "#dfe2e733" }
style.drag_overlay_tab   = { common.color "#e3b71d" }
style.good               = { common.color "#79c8c5" }
style.warn               = { common.color "#e3b71d" }
style.error              = { common.color "#ff3c41" }
style.modified           = { common.color "#3b7aba" }

-- CODE COLORS
style.syntax = {
    ["normal"]   = { common.color "#cccccc" },
    ["symbol"]   = { common.color "#cccccc" },
    ["comment"]  = { common.color "#778899" },
    ["keyword"]  = { common.color "#BF5C56" },
    ["keyword2"] = { common.color "#D7BD8A" },
    ["number"]   = { common.color "#DD949A" },
    ["literal"]  = { common.color "#BE926B" },
    ["string"]   = { common.color "#97B19C" },
    ["string2"]  = { common.color "#97B19C" },
    ["string3"]  = { common.color "#97B19C" },
    ["operator"] = { common.color "#DD949A" },
    ["function"] = { common.color "#D7BD8A" },
}

