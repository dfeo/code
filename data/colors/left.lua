local style = require "core.style"
local common = require "core.common"

-- Left (Hundred Rabbits) colorscheme for Code
-- Light, paper-like, warm gray background, near-black text

style.background     = { common.color "#d9d9d9" }
style.background2    = { common.color "#d9d9d9" }
style.background3    = { common.color "#d9d9d9" }

style.text           = { common.color "#1a1a1a" }
style.caret          = { common.color "#1a1a1a" }
style.accent         = { common.color "#1a1a1a" }
style.dim            = { common.color "#8a8a8a" }
style.divider        = { common.color "#b6b6b6" }
style.selection      = { common.color "#b9c4ce" }
style.line_number    = { common.color "#a3a3a3" }
style.line_number2   = { common.color "#1a1a1a" }
style.line_highlight = { common.color "#cfcfcf" }
style.scrollbar      = { common.color "#a3a3a3" }
style.scrollbar2     = { common.color "#7a7a7a" }
style.scrollbar_track= { common.color "#cfcecb" }

style.nagbar         = { common.color "#a8493b" }
style.nagbar_text    = { common.color "#f5f3ee" }
style.nagbar_dim     = { common.color "rgba(0, 0, 0, 0.45)" }

style.drag_overlay      = { common.color "rgba(0,0,0,0.06)" }
style.drag_overlay_tab  = { common.color "#1a1a1a" }

style.good      = { common.color "#4f7d52" }
style.warn      = { common.color "#a87b3a" }
style.error     = { common.color "#a8493b" }
style.modified  = { common.color "#a8493b" }

-- Syntax: muted, distraction-free
style.syntax["normal"]   = { common.color "#1a1a1a" }
style.syntax["symbol"]   = { common.color "#1a1a1a" }
style.syntax["comment"]  = { common.color "#8a8478" }
style.syntax["keyword"]  = { common.color "#5a4a8a" }
style.syntax["keyword2"] = { common.color "#8a5a4a" }
style.syntax["number"]   = { common.color "#8a6a3a" }
style.syntax["literal"]  = { common.color "#8a6a3a" }
style.syntax["string"]   = { common.color "#6a7a4a" }
style.syntax["operator"] = { common.color "#4a5a8a" }
style.syntax["function"] = { common.color "#4a6a8a" }

style.log["INFO"]  = { icon = "i", color = style.text }
style.log["WARN"]  = { icon = "!", color = style.warn }
style.log["ERROR"] = { icon = "!", color = style.error }

return style