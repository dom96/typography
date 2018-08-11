import vmath
import flippy
import font
import algorithm
import tables
import unicode

import rasterizer

import print


type
  Span* = object
    font: Font
    fontSize: float
    lineHeight: float
    tracking: float
    text: string

  GlyphPosition* = object
    font: Font
    fontSize: float
    lineHeight: float
    subPixelShift: float
    at: Vec2


proc kerningAdjustment*(font: var Font, prev, c: string): float =
  ## Get Kerning Adjustment between two letters
  var fontHeight = font.ascent - font.descent
  var scale = font.size / fontHeight
  if prev != "":
    var key = prev & ":" & c
    if font.kerning.hasKey(key):
      var kerning = font.kerning[key]
      return - kerning * scale


proc drawText*(font: var Font, image: var Image, start: Vec2, text: string) =
  ## Draw text string
  var at = start
  var prev = ""
  var fontHeight = font.ascent - font.descent
  var scale = font.size / fontHeight
  at.y += font.size
  for rune in runes(text):
    let c = $rune
    if rune == Rune(10):
      at.x = start.x
      at.y += font.lineHeight
      continue

    if c in font.glyphs:
      var glyph = font.glyphs[c]

      at.x += font.kerningAdjustment(prev, c)

      var glyphOffset: Vec2
      var subPixelShift = at.x - floor(at.x)
      var img = font.getGlyphImage(glyph, glyphOffset, subPixelShift=subPixelShift)
      image.blit(
        img,
        rect(0, 0, img.width, img.height),
        rect(int(at.x + glyphOffset.x), int(at.y + glyphOffset.y), img.width, img.height)
      )
      at.x += glyph.advance * scale

      prev = c

    else:
      discard
      #echo "missing", $c