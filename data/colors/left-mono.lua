local style = require "core.style"
local common = require "core.common"

-- Left (Hundred Rabbits) colorscheme for Code — monochrome variant
-- Pure grayscale syntax highlighting: keyword weight + italic for comments
-- differentiates tokens without using color. Pure distraction-free.

style.background     = { common.color "#d9d9d9" }
style.background2    = { common.color "#d9d9d9" }
style.background3    = { common.color "#d9d9d9" }

style.text           = { common.color "#4a4a4a" }
style.caret          = { common.color "#000000" }
style.accent         = { common.color "#000000" }
style.dim            = { common.color "#8a8a8a" }
style.divider        = { common.color "#b6b6b6" }
style.selection      = { common.color "#b9c4ce" }
style.line_number    = { common.color "#a3a3a3" }
style.line_number2   = { common.color "#1a1a1a" }
style.line_highlight = { common.color "#cfcfcf" }
style.scrollbar      = { common.color "#a3a3a3" }
style.scrollbar2     = { common.color "#7a7a7a" }
style.scrollbar_track= { common.color "#cfcecb" }

style.nagbar         = { common.color "#1a1a1a" }
style.nagbar_text    = { common.color "#f5f3ee" }
style.nagbar_dim     = { common.color "rgba(0, 0, 0, 0.45)" }

style.drag_overlay      = { common.color "rgba(0,0,0,0.06)" }
style.drag_overlay_tab  = { common.color "#1a1a1a" }

style.good      = { common.color "#1a1a1a" }
style.warn      = { common.color "#3a3a3a" }
style.error     = { common.color "#000000" }
style.modified  = { common.color "#000000" }

-- Syntax: pure grayscale (black -> light gray)
style.syntax["normal"]   = { common.color "#4a4a4a" } -- base text (medium gray, recedes)
style.syntax["symbol"]   = { common.color "#7a7a7a" } -- operators, punctuation (light)
style.syntax["comment"]  = { common.color "#a8a8a8" } -- comments (very light, italic)
style.syntax["keyword"]  = { common.color "#000000" } -- pure black, bold
style.syntax["keyword2"] = { common.color "#2a2a2a" } -- self, types (dark, bold)
style.syntax["number"]   = { common.color "#2a2a2a" } -- numerics (dark)
style.syntax["literal"]  = { common.color "#2a2a2a" } -- true/false/null (dark)
style.syntax["string"]   = { common.color "#5a5a5a" } -- medium gray (italic)
style.syntax["operator"] = { common.color "#1a1a1a" } -- =, +, =>, near-black
style.syntax["function"] = { common.color "#000000" } -- function names, bold black

-- Italic for comment + string; bold for keyword + function + keyword2
style.syntax_fonts = {}
style.syntax_fonts["comment"]  = renderer.font.load(
  DATADIR .. "/fonts/FiraCode-Regular.ttf", 14 * SCALE,
  { italic = true, bold = false })
style.syntax_fonts["string"]   = renderer.font.load(
  DATADIR .. "/fonts/FiraCode-Regular.ttf", 14 * SCALE,
  { italic = true, bold = false })
style.syntax_fonts["keyword"]  = renderer.font.load(
  DATADIR .. "/fonts/FiraCode-Regular.ttf", 14 * SCALE,
  { italic = false, bold = true })
style.syntax_fonts["keyword2"] = renderer.font.load(
  DATADIR .. "/fonts/FiraCode-Regular.ttf", 14 * SCALE,
  { italic = false, bold = true })
style.syntax_fonts["function"] = renderer.font.load(
  DATADIR .. "/fonts/FiraCode-Regular.ttf", 14 * SCALE,
  { italic = false, bold = true })

style.log["INFO"]  = { icon = "i", color = style.text }
style.log["WARN"]  = { icon = "!", color = style.warn }
style.log["ERROR"] = { icon = "!", color = style.error }

return style