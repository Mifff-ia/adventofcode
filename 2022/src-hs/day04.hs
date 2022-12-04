{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text as T
import qualified Data.Text.IO as TIO

type Start = Int

type End = Int

data IDRange = IDRange Start End

splitOnceOn :: T.Text -> T.Text -> (T.Text, T.Text)
splitOnceOn char text = let [left, right] = T.splitOn char text in (left, right)

both :: (a -> b) -> (a, a) -> (b, b)
both f (x, y) = (f x, f y)

tRead :: Read a => T.Text -> a
tRead = read . T.unpack

fullyContains :: IDRange -> IDRange -> Bool
fullyContains (IDRange s1 e1) (IDRange s2 e2) = (s1 <= s2 && e2 <= e1) || (s2 <= s1 && e1 <= e2)

overlaps :: IDRange -> IDRange -> Bool
overlaps (IDRange s1 e1) (IDRange s2 e2) = (s1 <= s2 && s2 <= e1) || (s1 <= e2 && e2 <= e1)

parseIDRange :: T.Text -> IDRange
parseIDRange = uncurry IDRange . both tRead . splitOnceOn "-" -- let [start, end] = T.splitOn "-" text in IDRange (tRead start) (tRead end)

main :: IO ()
main = do
  text <- TIO.getContents
  let pairs = map (both parseIDRange . splitOnceOn ",") $ T.lines text
  print $ length $ filter (\(a, b) -> fullyContains a b || fullyContains b a) pairs
  print $ length $ filter (\(a, b) -> overlaps a b || overlaps b a) pairs
