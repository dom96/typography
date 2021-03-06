## Utilisites for finding fonts installed, or for fall backs when fonts are not found.

import strformat, ospaths, os, strutils

when defined(MacOSX):
  let fontDirecotires* = @[
    "/System/Library/Fonts/",
    "/Library/Fonts/",
    getHomeDir() & "/Library/Fonts/"
  ]
elif defined(windows):
  let fontDirecotires* = @[
    r"C:\Windows\Fonts",
  ]
else:
  let fontDirecotires* = @[]

proc getSystemFonts*(): seq[string] =
  for fontDir in fontDirecotires:
    for kind, path in walkDir(fontDir):
      result.add path

proc findFont*(fontName: string): string =
  for fontDir in fontDirecotires:
    for kind, path in walkDir(fontDir):
      let (dir, name, ext) = path.splitFile()
      if name.toLowerAscii() == fontName.toLowerAscii():
        return path

when isMainModule:
  echo getSystemFonts()
  echo findFont("Arial")