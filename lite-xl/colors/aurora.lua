-- ArchLabs colorscheme for lite-xl, Author: Barret E <archus@protonmail>
local style = require "core.style"
local common = require "core.common"

-- Application style --
style.background         = { common.color "#292a47" }
style.background2        = { common.color "#21232e" }
style.background3        = { common.color "#21232e" }
style.text               = { common.color "#8e9feb" }
style.caret              = { common.color "#dbaec4" }
style.accent             = { common.color "#bf9eb9" }
style.dim                = { common.color "#8893a5" }
style.divider            = { common.color "#21232e" }
style.selection          = { common.color "#2e3140" }
style.line_number        = { common.color "#8893a5" }
style.line_number2       = { common.color "#bf9eb9" }
style.line_highlight     = { common.color "#21232e" }
style.scrollbar          = { common.color "#2c3440" }
style.scrollbar2         = { common.color "#3a3c66" }
style.scrollbar_track    = { common.color "#00000000" }
style.nagbar             = { common.color "#aa4677" }
style.nagbar_text        = { common.color "#f7c5dd" }
style.nagbar_dim         = { common.color "rgba(0, 0, 0, 0.45)" }
style.drag_overlay       = { common.color "#dfe2e733" }
style.drag_overlay_tab   = { common.color "#e3b71d" }
style.good               = { common.color "#79c8c5" }
style.warn               = { common.color "#e3b71d" }
style.error              = { common.color "#ff3c41" }
style.modified           = { common.color "#3b7aba" }

-- Syntax --
style.syntax             = {}
style.syntax["normal"]   = { common.color "#c8c3ff" }
style.syntax["symbol"]   = { common.color "#c8c3ff" }
style.syntax["comment"]  = { common.color "#5c6476" }
style.syntax["keyword"]  = { common.color "#ca1b71" }
style.syntax["keyword2"] = { common.color "#a68f62" }
style.syntax["number"]   = { common.color "#dc4673" }
style.syntax["literal"]  = { common.color "#87708c" }
style.syntax["string"]   = { common.color "#8E9FEB" }
style.syntax["string2"]  = { common.color "#8E9FEB" }
style.syntax["string3"]  = { common.color "#8E9FEB" }
style.syntax["operator"] = { common.color "#9f93d9" }
style.syntax["function"] = { common.color "#4f70b3" }

-- Lint+ --
style.lint               = {}
style.lint["info"]       = { common.color "#3b7aba" }
style.lint["hint"]       = { common.color "#79c8c5" }
style.lint["warning"]    = { common.color "#e3b71d" }
style.lint["error"]      = { common.color "#ff3c41" }
