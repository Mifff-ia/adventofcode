{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Data.List
import qualified Data.Text as T
import           Fmt

rmDup :: T.Text -> T.Text
rmDup = T.pack . map head . group . sort . T.unpack

parse :: T.Text -> [[T.Text]]
parse = filter (not . T.null . head) . groupBy check . T.lines
  where
    check :: T.Text -> T.Text -> Bool
    check x y = not $ T.null x || T.null y

main :: IO ()
main = do
  input <- T.pack <$> readFile "resources/aoc6.txt"
  let parsedInput = parse input
  fmtLn $ "Answer 1: "+|answer1 parsedInput|+"\nAnswer 2: "+|answer2 parsedInput|+""

answer1 :: [[T.Text]] -> Int
answer1 = sum . map (T.length . rmDup . T.concat)

answer2 :: [[T.Text]] -> Int
answer2 = sum . map (length . foldl intersect ['a'..'z'] . map T.unpack)
