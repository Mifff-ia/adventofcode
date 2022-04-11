{-# LANGUAGE TupleSections #-}
module Main where

import qualified Data.Text as T
import qualified Data.Vector as V
import qualified Util as U
import Data.List (minimumBy, maximumBy)
import Data.Maybe (catMaybes,mapMaybe)

main :: IO ()
main = U.generateMain 13 parser answer1 $ answer2 . snd

parser :: T.Text -> (Int, [Maybe Int])
parser input =
  let [time, busIDs] = T.lines input
   in (read $ T.unpack time, map (ids . T.unpack) $ T.splitOn "," busIDs)
  where
    ids x = if x == "x" then Nothing else Just $ read x

answer1 :: (Int, [Maybe Int]) -> Int
answer1 (time, busIDs) = (\(x, y) -> x * (y - time)) $ minimumBy (\(_, a) (_, b) -> compare a b) $ mapMaybe (f <$>) busIDs
  where f x = (x, x * (time `div` x + 1))

answer2 :: [Maybe Int] -> Int
answer2 busIDs = f firstNum constraints
  where 
    f :: Int -> [(Int, Int)] -> Int
    f num list = if all (\(x, y) -> (num + y) `mod` x == 0) list then num else f (num + firstNum) list
    firstNum = fst . head $ constraints
    constraints :: [(Int, Int)]
    constraints = catMaybes $ zipWith (\x y -> (, y) <$> x) busIDs [0..]
