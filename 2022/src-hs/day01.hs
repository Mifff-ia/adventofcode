{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

import Data.List (sortBy)

default (T.Text)

tRead :: Read a => T.Text -> a
tRead = read . T.unpack

elf_calories :: T.Text -> [[Int]]
elf_calories = map f . T.splitOn "\n\n"
  where f :: T.Text -> [Int]
        f = map tRead . T.lines

totalCarried = sum

answer1 :: [[Int]] -> Int
answer1 = maximum . map totalCarried

answer2 :: [[Int]] -> Int
answer2 = sum . take 3 . sortBy (flip compare) . map totalCarried

main :: IO ()
main = do
  text <- TIO.getContents
  let parsed = elf_calories text
  print $ answer1 parsed
  print $ answer2 parsed
  pure ()
