{-# LANGUAGE RecordWildCards, ViewPatterns #-}
module Draw where

import GHC.Arr
import Graphics.Gloss hiding (Text)

import Assets
import CharChart
import Level
import Pictures
import Types
import World


drawSprite :: Assets -> Entity -> Picture
drawSprite (Assets {..}) (Object "Sheets")
  = boxed (128, 128) cellPixelSize sheets
drawSprite (Assets {..}) (Object "Giggles")
  = boxed (128, 127) cellPixelSize giggles
drawSprite (Assets {..}) (Object name)
  = color green (circleSolid ((cellPixelSize - 8) / 2))
 <> boxedText charChart name ((cellPixelSize - 8) / realToFrac (sqrt 2 :: Float))
drawSprite (Assets {..}) (Text word)
  = boxedText charChart word (cellPixelSize - 8)

drawLevel :: Assets -> Level -> Picture
drawLevel assets lvl@(Level {..})
  = translate2D (negate (recenter cellPixelSize (totalPixelSize lvl)))
  $ mconcat
  [ translate2D p $ ( color (greyN 0.8)
                    $ uncurry rectangleWire cellPixelSize
                    )
                 <> maybe mempty (drawSprite assets) (levelArray ! (i,j))
  | (i,j) <- indices levelArray
  , let p = cellPixelSize * (fromIntegral i, fromIntegral j)
  ]

totalPixelSize :: Level -> PixelSize
totalPixelSize lvl = cellPixelSize * fromIntegral2D (levelCellSize lvl)

displayWorld :: Assets -> World -> Picture
displayWorld assets@(Assets {..}) (World {..})
  = drawLevel assets level
