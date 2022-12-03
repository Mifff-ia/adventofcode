{-# LANGUAGE OverloadedStrings #-}

import Data.Char (isUpper, ord)
import Data.List (sortBy)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.List.NonEmpty as NE

group :: Int -> [a] -> [[a]]
group _ [] = []
group n l
  | n > 0 = take n l : group n (drop n l)
  | otherwise = error "Negative or zero n"

commonInHalves :: T.Text -> Char
commonInHalves bag =
  let (left, right) = T.splitAt (T.length bag `div` 2) bag
   in T.head $ T.filter (`T.elem` right) left

priority :: Char -> Int
priority x = if isUpper x then ord x - ord 'A' + 27 else ord x - ord 'a' + 1

answer1 :: [T.Text] -> Int
answer1 = sum . map (priority . commonInHalves)

common :: NE.NonEmpty T.Text -> Char
common (firstBag NE.:| ruckSacks) = T.head $ T.filter (\x -> all (x `T.elem`) ruckSacks) firstBag

answer2 :: [T.Text] -> Int
answer2 = sum . map (priority . common . NE.fromList) . group 3

main :: IO ()
main = do
  text <- TIO.getContents
  let ruckSacks = T.lines text
  print $ answer1 ruckSacks
  print $ answer2 ruckSacks
