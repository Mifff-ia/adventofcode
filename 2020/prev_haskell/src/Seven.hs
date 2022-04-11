{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.Map.Strict as M
import           Data.Maybe      (fromJust)
import qualified Data.Set        as S
import qualified Data.Text       as T
import           Fmt             (fmtLn)

data Rule = Rule T.Text (M.Map T.Text Int) deriving Show

parse :: T.Text -> [Rule]
parse = map (formatting . T.splitOn " bags contain ") . T.lines
  where
    formatting :: [T.Text] -> Rule
    formatting [container, containees] = Rule container $ fitToMap containees
    fitToMap :: T.Text -> M.Map T.Text Int
    fitToMap = M.fromList . clauses
      where
        clauses :: T.Text -> [(T.Text, Int)]
        clauses = map (mapEntry . T.words .  endStrip) . filter (/=T.pack "no other bags") .  T.splitOn ", " . T.init
        mapEntry :: [T.Text] -> (T.Text, Int)
        mapEntry (x:xs) = (T.unwords xs, read $ T.unpack x)
        endStrip :: T.Text -> T.Text
        endStrip clause = fromJust $ T.stripSuffix (if T.isSuffixOf "s" clause then " bags" else " bag") clause

main :: IO ()
main = do
  input <- T.pack <$> readFile "resources/aoc7.txt"
  print $ answer2 $ parse input

answer1 :: [Rule] -> Int
answer1 rules = length $ S.toList $ f S.empty rules $ contains "shiny gold" rules
  where f :: S.Set T.Text -> [Rule] -> S.Set T.Text -> S.Set T.Text
        f acc rule set
          | set == S.empty = acc
          | otherwise = f (S.union set acc) rule $ S.unions $ S.map (`contains` rule) $ S.difference set acc
        contains :: T.Text -> [Rule] -> S.Set T.Text
        contains text = S.fromList . filter (not . T.null) . map (test text)
          where
            test :: T.Text -> Rule -> T.Text
            test text (Rule name map) = if text `M.member` map
                                           then name else ""

answer2 :: [Rule] -> Int
answer2 rules = f 0 rules $ containedBy "shiny gold" rules
  where f :: Int -> [Rule] -> [(T.Text, Int)] -> Int
        f acc _ [] = acc
        f acc rules table = f (acc + sum (map snd table)) rules $ concatMap (\(name, number) -> inject number (name `containedBy` rules)) table
        containedBy :: T.Text -> [Rule] -> [(T.Text, Int)]
        containedBy text rules = let (Rule _ bags) = head $ filter (\(Rule x _) -> x == text) rules
                                  in M.toList bags
        -- used to multiply the number of inner bags by the number of bags containing it
        inject :: Int -> [(T.Text, Int)] -> [(T.Text, Int)]
        inject int entry = map (\(x, y) -> (x, y*int)) entry
