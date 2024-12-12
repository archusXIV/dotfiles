-- ArchLabs colorscheme for lite-xl, Author: Barret E <archus@protonmail>
local style = require "core.style"
local common = require "core.common"

----------------- Application colors ----------------
style.background         = { common.color "#222831" }
style.background2        = { common.color "#1e232b" }
style.background3        = { common.color "#1e232b" }
style.text               = { common.color "#96B5B4" }
style.caret              = { common.color "#E1E1E1" }
style.accent             = { common.color "#EBCB8B" }
style.dim                = { common.color "#8893a5" }
style.divider            = { common.color "#1e232b" }
style.selection          = { common.color "#2c3440" }
style.line_number        = { common.color "#8893a5" }
style.line_number2       = { common.color "#EBCB8B" }
style.line_highlight     = { common.color "#242a34" }
style.scrollbar          = { common.color "#2c3440" }
style.scrollbar2         = { common.color "#A3BE8C" }
style.scrollbar_track    = { common.color "#00000000" }
style.nagbar             = { common.color "#BF616A" }
style.nagbar_text        = { common.color "#E1E1E1" }
style.nagbar_dim         = { common.color "rgba(0, 0, 0, 0.45)" }
style.drag_overlay       = { common.color "#dfe2e733" }
style.drag_overlay_tab   = { common.color "#e3b71d" }
style.good               = { common.color "#79c8c5" }
style.warn               = { common.color "#e3b71d" }
style.error              = { common.color "#ff3c41" }
style.modified           = { common.color "#3b7aba" }

-------------------- Code colors --------------------
style.syntax             = {}
style.syntax["normal"]   = { common.color "#E1E1E0" }
style.syntax["symbol"]   = { common.color "#E1E1E0" }
style.syntax["comment"]  = { common.color "#778899" }
style.syntax["keyword"]  = { common.color "#BF616A" }
style.syntax["keyword2"] = { common.color "#EBCB8B" }
style.syntax["number"]   = { common.color "#B48EAD" }
style.syntax["literal"]  = { common.color "#A3BE8C" }
style.syntax["string"]   = { common.color "#96B5B4" }
style.syntax["string2"]  = { common.color "#96B5B4" }
style.syntax["string3"]  = { common.color "#96B5B4" }
style.syntax["operator"] = { common.color "#B48EAD" }
style.syntax["function"] = { common.color "#EBCB8B" }

