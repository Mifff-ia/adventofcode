{-# LANGUAGE OverloadedStrings #-}

import Data.Char (ord)
import Data.List
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

data Hand = Rock | Paper | Scissors
  deriving (Enum, Eq, Show)

data Result = Loss | Draw | Win
  deriving (Enum, Show)

handScore :: Hand -> Int
handScore = (+) 1 . fromEnum

resultScore :: Result -> Int
resultScore = (*) 3 . fromEnum

playerHand :: Char -> Hand
playerHand x = toEnum $ ord x - ord 'X'

opponentHand :: Char -> Hand
opponentHand x = toEnum $ ord x - ord 'A'

whatResult :: Char -> Result
whatResult x = toEnum $ ord x - ord 'X'

textToMatch :: T.Text -> (Hand, Hand)
textToMatch text =
  let opponent = T.index text 0
      player = T.index text 2
   in (opponentHand opponent, playerHand player)

textToCondition :: T.Text -> (Hand, Result)
textToCondition text =
  let opponent = T.index text 0
      result = T.index text 2
   in (opponentHand opponent, whatResult result)

handForCondition :: (Hand, Result) -> Hand
handForCondition (hand, result) = toEnum $ (fromEnum hand + fromEnum result + 2) `mod` 3

resultForMatch :: (Hand, Hand) -> Result
resultForMatch (opponent, player)
  | player == opponent = Draw
  | toEnum ((fromEnum player + 1) `mod` 3) == opponent = Loss
  | otherwise = Win

score :: Hand -> Result -> Int
score hand result = handScore hand + resultScore result

answer1 = sum . map calc
  where
    calc match@(opponent, player) = score player (resultForMatch match)

answer2 = sum . map calc
  where
    calc match@(opponent, result) = score (handForCondition match) result

main :: IO ()
main = do
  text <- TIO.getContents
  let matches = map textToMatch $ T.lines text
  let conditions = map textToCondition $ T.lines text
  -- mapM_ (TIO.putStrLn . T.pack . debugging) $ take 10 matches
  print $ answer1 matches
  print $ answer2 conditions

debugging x@(opponent, player) =
  unwords
    [ show $ handScore player,
      show $ resultScore $ resultForMatch x,
      show x,
      show $ resultForMatch x
    ]
