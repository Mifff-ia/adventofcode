module Util where

import qualified Data.Text as T
import qualified Data.Text.IO as T.IO

parseInput :: Int -> (T.Text -> a) -> IO a
parseInput a parser = parser <$> T.IO.readFile ("resources/day" ++ show a ++ ".txt")

printAnswers :: (a -> Int) -> (a -> Int) -> a -> IO ()
printAnswers answer1 answer2 input = putStrLn $ "Answer 1: " ++ show (answer1 input) ++ " Answer 2: " ++ show (answer2 input)

generateMain day parser answer1 answer2 = parseInput day parser >>= printAnswers answer1 answer2
