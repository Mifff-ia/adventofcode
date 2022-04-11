{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Data.Char (isAlpha, isDigit, isHexDigit)
import           Data.List (groupBy)
import qualified Data.Text as T
import           Fmt       (fmtLn, (+|), (|+))

type Year = Int

data Length = Centimeters Int
            | Inches Int
            deriving Show

data Field = Byr Year
           | Iyr Year
           | Eyr Year
           | Hgt Length
           | Hcl T.Text
           | Ecl T.Text
           | Pid T.Text
           | Cid Int
           deriving Show

type Input = [[Field]]

-- parse :: T.Text -> Input
parse = map (map (T.split (==':')) . concatMap T.words) . filter (not . T.null . head) . groupBy check . T.lines
  where
    check :: T.Text -> T.Text -> Bool
    check x y = not $ T.null x || T.null y

fitToField :: [T.Text] -> Field
fitToField [x, y] = let num = read $ T.unpack y
                     in case x of
                      "byr" -> Byr num
                      "iyr" -> Iyr num
                      "eyr" -> Eyr num
                      "hgt" -> let (measure,units) = T.break isAlpha y
                                in Hgt $ (if units == "in" then Inches else Centimeters) $ read $ T.unpack measure
                      "hcl" -> Hcl y
                      "ecl" -> Ecl y
                      "pid" -> Pid y
                      "cid" -> Cid num

main :: IO ()
main = do
  input <- T.pack <$> readFile "resources/aoc4.txt"
  let parsedInput = parse input
  fmtLn $ "Answer 1: "+|answer1 parsedInput|+"\nAnswer 2: "+|answer2 parsedInput|+""

answer1 :: [[[T.Text]]] -> Int
answer1 text = length $ validFields text

validFields :: [[[T.Text]]] -> [[[T.Text]]]
validFields text = filter records text
  where
    records :: [[T.Text]] -> Bool
    records text = let x :: [T.Text]
                       x = map head text
                    in all (`elem` x) ["byr", "iyr", "eyr", "hgt", "ecl", "hcl", "pid"]


answer2 :: [[[T.Text]]] -> Int
answer2 = length . filter (all predicate) . map (map fitToField) . validFields
  where predicate x = case x of
                        Byr year -> year >= 1920 && year <= 2002
                        Iyr year -> year >= 2010 && year <= 2020
                        Eyr year -> year >= 2020 && year <= 2030
                        Hgt (Centimeters measure) -> measure >= 150 && measure <= 193
                        Hgt (Inches measure)      -> measure >= 59 && measure <= 76
                        Hcl color -> T.head color == '#' && T.all isHexDigit (T.tail color) && T.length (T.tail color) == 6
                        Ecl color -> color `elem` ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
                        Pid num -> T.all isDigit num && T.length num == 9
                        Cid _ -> True
