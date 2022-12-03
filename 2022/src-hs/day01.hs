{-# LANGUAGE OverloadedStrings #-}

import Data.List (sortBy)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

default (T.Text)

tRead :: Read a => T.Text -> a
tRead = read . T.unpack

elfCalories :: T.Text -> [[Int]]
elfCalories = map f . T.splitOn "\n\n"
  where
    f :: T.Text -> [Int]
    f = map tRead . T.lines

totalCarried = sum

answer1 :: [[Int]] -> Int
answer1 = maximum . map totalCarried

answer2 :: [[Int]] -> Int
answer2 = sum . take 3 . sortBy (flip compare) . map totalCarried

main :: IO ()
main = do
  text <- TIO.getContents
  let parsed = elfCalories text
  print $ answer1 parsed
  print $ answer2 parsed
  pure ()
