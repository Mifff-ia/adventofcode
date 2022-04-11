{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.Set  as S
import qualified Data.Text as T

data Opcode = Nop T.Text
            | Acc T.Text
            | Jmp T.Text
            deriving Show

data Console = Console {
                pc   :: Int,
                acc  :: Int,
                reel :: [Opcode]
                       } deriving Show

parse :: T.Text -> [Opcode]
parse = map (opcode . T.words) . T.lines
  where opcode :: [T.Text] -> Opcode
        opcode [op, num] = let n = num
                            in case op of
                                 "nop" -> Nop n
                                 "acc" -> Acc n
                                 "jmp" -> Jmp n

main :: IO ()
main = do
  input <- T.pack <$> readFile "resources/aoc8.txt"
  print $ parse input


