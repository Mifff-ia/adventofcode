{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Data.List  (tails)
import           Data.Maybe (fromJust, fromMaybe)
import qualified Data.Text  as T
import           Fmt        (fmtLn, (+|), (|+))

-- copied this from stackoverflow 34044366
pairs :: [a] -> [(a, a)]
pairs l = [(x,y) | (x:ys) <- tails l, y <- ys]

parse :: T.Text -> [Int]
parse =  map (read . T.unpack) . T.lines

main :: IO ()
main = do
  input <- T.pack <$> readFile "resources/aoc9.txt"
  let parsedInput = parse input
  fmtLn $ "Answer 1: "+|answer1 25 parsedInput|+"\nAnswer 2: "+|answer2 parsedInput|+""

answer1 :: Int -> [Int] -> Maybe Int
answer1 prevNum list
  | length list == prevNum = Nothing
  | otherwise = let sums = map (uncurry (+)) $ pairs $ take prevNum list
                    number = list !! prevNum
                 in if number `notElem` sums
                       then Just number
                       else answer1 prevNum $ tail list

answer2 :: [Int] -> Int
answer2 = f 2
  where f :: Int -> [Int] -> Int
        f x list = let ans = check x list $ fromJust $ answer1 25 list
                    in fromMaybe (f (x+1) list) ans
        check :: Int -> [Int] -> Int -> Maybe Int
        check x list ans
          | length list <= x = Nothing
          | otherwise = let y = take x list
                         in if sum y == ans
                               then Just $ maximum y + minimum y
                               else check x (tail list) ans
