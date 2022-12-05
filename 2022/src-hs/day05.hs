{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.Text.Read as TR
import Data.List

tRead :: Read a => T.Text -> a
tRead = read . T.unpack

type Stack = [Char]

boxesToChars :: String -> String
boxesToChars [] = []
boxesToChars (' ' : _ : n : _ : xs) = n : boxesToChars xs
boxesToChars (_ : n : _ : xs) = n : boxesToChars xs
boxesToChars _ = error "This shouldn't happen"

addStackLayer :: T.Text -> [Stack] -> [Stack]
addStackLayer text s = zipWith addBox s (boxesToChars $ T.unpack text)
  where
    addBox stack box =
      if box == ' '
        then stack
        else box : stack

parseStack :: [T.Text] -> [Stack]
parseStack = foldr addStackLayer (repeat [])

type Amount = Int

type From = Int

type To = Int

data Move = Move Amount From To
  deriving (Show)

replaceNth :: Int -> a -> [a] -> [a]
replaceNth _ _ [] = []
replaceNth n newVal (x : xs)
  | n == 0 = newVal : xs
  | otherwise = x : replaceNth (n - 1) newVal xs

parseMove :: T.Text -> Move
parseMove order =
  let xs = T.words order
   in Move (tRead $ xs !! 1) (tRead $ xs !! 3) (tRead $ xs !! 5)

execMoveBy :: (Stack -> Stack) -> [Stack] -> Move -> [Stack]
execMoveBy moveAlgorithm s (Move amount from to) =
  let (movedItems, fromRemainder) = splitAt amount $ s !! (from - 1)
      newTo = moveAlgorithm movedItems ++ (s !! (to - 1))
   in replaceNth (from - 1) fromRemainder $ replaceNth (to - 1) newTo s

main :: IO ()
main = do
  text <- TIO.getContents
  let [stackData, moveData] = T.splitOn "\n\n" text
  let stack = parseStack $ init $ T.lines stackData
  let moves = map parseMove $ T.lines moveData
  -- mapM_ (print . execMoveBy reverse stack) (inits moves)
  let endStack9000 = foldl (execMoveBy reverse) stack moves
  let endStack9001 = foldl (execMoveBy id) stack moves
  -- print endStack

  print $ map head endStack9000
  print $ map head endStack9001
