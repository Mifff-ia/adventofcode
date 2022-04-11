{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.Text as T
import           Fmt

data Seat = Seat {row :: Int, column :: Int}

find' :: (Num a, Integral a) => (Char, Char) -> T.Text -> a
find' (down, up) text = (if T.last text == down then fst else snd) $ T.foldl check (0, bound) $ T.init text
  where
    bound = 2 ^ T.length text - 1
    check (x, y) char
      | char == down = (x, (y-x) `div` 2 + x)
      | char == up = (y - (y-x) `div` 2, y)

findRow :: (Num a, Integral a) => T.Text -> a
findRow = find' ('F', 'B')

findColumn = find' ('L', 'R')

seatID :: [(T.Text, T.Text)] -> [Int]
seatID = map (\(x, y) -> findRow x * 8 + findColumn y)

parse :: T.Text -> [(T.Text, T.Text)]
parse = map (T.splitAt 7) . T.lines

main :: IO ()
main = do
  input <- T.pack <$> readFile "resources/aoc5.txt"
  let parsedInput = parse input
  fmtLn $ "Answer 1: "+|answer1 parsedInput|+"\nAnswer 2: "+|answer2 parsedInput|+""

answer1 :: [(T.Text, T.Text)] -> Int
answer1 = maximum . seatID

answer2 :: [(T.Text, T.Text)] -> Int
answer2 input = let highest = answer1 input
                    seat = seatID input
                 in last $ filter (`notElem` seat) [1..highest]
