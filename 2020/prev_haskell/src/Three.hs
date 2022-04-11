{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.Text as T
import           Fmt

data Slope = Slope Int Int

main :: IO ()
main = do
  input <- T.pack <$> readFile "resources/aoc3.txt"
  let x = T.lines input
  fmtLn $ "Answer 1: "+|answer1 (Slope 3 1) x|+"\nAnswer 2: "+|answer2 x|+""

answer1 :: Slope -> [T.Text] -> Int
answer1 slope@(Slope x y) text = let len = T.length . head $ text
                                     (_, _, acc) = foldl (check len slope) (x, y, 0) text in acc

answer2 :: [T.Text] -> Int
answer2 text = foldl (\x y -> x * answer1 y text) 1 slope
  where slope :: [Slope]
        slope = [ Slope 1 1,
                  Slope 3 1,
                  Slope 5 1,
                  Slope 7 1,
                  Slope 1 2 ]

check :: Int -> Slope -> (Int, Int, Int) -> T.Text -> (Int, Int, Int)
check len (Slope right down) (x, 0, acc) text = (x + right, down - 1, if T.index text (x `mod` len) == '#'
                                                                    then acc+1 else acc)
check _ _ (x, y, acc) _ = (x, y - 1, acc)

