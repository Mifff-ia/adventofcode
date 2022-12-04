{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text as T
import qualified Data.Text.IO as TIO

type Start = Int

type End = Int

data IDRange = IDRange Start End

tRead :: Read a => T.Text -> a
tRead = read . T.unpack

fullyContains :: IDRange -> IDRange -> Bool
fullyContains (IDRange s1 e1) (IDRange s2 e2) = (s1 <= s2 && e2 <= e1) || (s2 <= s1 && e1 <= e2)

overlaps :: IDRange -> IDRange -> Bool
overlaps (IDRange s1 e1) (IDRange s2 e2) = (s1 <= s2 && s2 <= e1) || (s1 <= e2 && e2 <= e1)

parseIDRange :: T.Text -> IDRange
parseIDRange text = let [start, end] = T.splitOn "-" text in IDRange (tRead start) (tRead end)

main :: IO ()
main = do
  text <- TIO.getContents
  let pairs = map (\x -> let [elf1, elf2] = T.splitOn "," x in (parseIDRange elf1, parseIDRange elf2)) $ T.lines text
  print $ length $ filter (\(a, b) -> fullyContains a b || fullyContains b a) pairs
  print $ length $ filter (\(a, b) -> overlaps a b || overlaps b a) pairs
