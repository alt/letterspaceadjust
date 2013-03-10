-- 
--  This is file `letterspaceadjust.lua',
--  generated with the docstrip utility.
-- 
--  The original source files were:
-- 
--  letterspaceadjust.dtx  (with options: `lua')
--  
--  EXPERIMENTAL CODE
--  
--  This package is copyright © 2013 Arno L. Trautmann. It may be distributed and/or
--  modified under the conditions of the LaTeX Project Public License, either version 1.3c
--  of this license or (at your option) any later version. This work has the LPPL mainten-
--  ance status ‘maintained’.
local nodenew = node.new
local nodecopy = node.copy
local nodeinsertbefore = node.insert_before
local nodeinsertafter = node.insert_after
local nodeid = node.id
local nodetraverseid = node.traverse_id

Hhead = nodeid("hhead")
RULE = nodeid("rule")
GLUE = nodeid("glue")
WHAT = nodeid("whatsit")
COL = node.subtype("pdf_colorstack")
GLYPH = nodeid("glyph")

local letterspace_glue = nodenew(nodeid"glue")
letterspace_spec = nodenew(nodeid"glue_spec")
local letterspace_pen = nodenew(nodeid"penalty")

letterspace_spec.width   = tex.sp"0pt"
letterspace_spec.stretch = tex.sp"0.02em"
letterspace_glue.spec    = letterspace_spec
letterspace_pen.penalty  = 10000
letterspaceadjust = function(head)
  for glyph in nodetraverseid(nodeid"glyph", head) do
    if glyph.prev and (glyph.prev.id == nodeid"glyph" or glyph.prev.id == nodeid"disc" or glyph.prev.id == nodeid"kern") then
      local g = nodecopy(letterspace_glue)
      nodeinsertbefore(head, glyph, g)
      nodeinsertbefore(head, g, nodecopy(letterspace_pen))
    end
  end
  return head
end
textletterspaceadjust = function(head)
  for glyph in nodetraverseid(nodeid"glyph", head) do
    if node.has_attribute(glyph,luatexbase.attributes.letterspaceadjustattr) then
      if glyph.prev and (glyph.prev.id == node.id"glyph" or glyph.prev.id == node.id"disc") then
        local g = node.copy(letterspace_glue)
        nodeinsertbefore(head, glyph, g)
        nodeinsertbefore(head, g, nodecopy(letterspace_pen))
      end
    end
  end
  luatexbase.remove_from_callback("pre_linebreak_filter","textletterspaceadjust")
  return head
end
-- 
--  End of File `letterspaceadjust.lua'.
