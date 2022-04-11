-- This code is broken, I was able to do part 1
module Main where

import qualified Util as U
import qualified Data.Text as T
import qualified Data.Vector as V
import qualified Control.Monad.Trans.Reader as R

data Tile = Floor | Chair Bool
  deriving (Show,Eq)

type Room = V.Vector (V.Vector Tile)

main :: IO ()
main = U.generateMain 11 parser answer1 answer2
{- main = do 
          room <- U.parseInput 11 parser
          let indices = [[(x, y) | x <- [0 .. (length (head room) - 1)]] | y <- [0..(length room - 1)]]
          print $ next indices $ next indices $ next indices $ next indices $ next indices room -}

parser :: T.Text -> Room
parser = V.fromList . map (V.fromList . map f . T.unpack) . T.lines
  where f x
          | x == '.' = Floor
          | otherwise = Chair False

neighbors :: (Int, Int) -> Room -> Int
neighbors (x, y) room = sum $ map boundedGet [(x-1,y-1), (x, y-1), (x+1,y-1), (x-1, y), (x+1, y), (x-1, y+1), (x, y+1), (x+1, y+1)]
  where boundedGet (x, y) = let width = V.length $ V.head room
                                len = V.length room
                             in if not (x < 0 || x >= width || y < 0 || y >= len) && room V.! y V.! x == Chair True
                                 then 0
                                 else 1

seatChange :: Int -> Tile -> Tile
seatChange neighbors = f
  where f (Chair True) = Chair $ neighbors < 4
        f (Chair False) = Chair $ neighbors == 0
        f Floor = Floor

next :: Room -> Room
next room = V.imap (\y row -> V.imap (\x tile -> seatChange (neighbors (x, y) room) tile) row) room

stabilise :: Room -> Room
stabilise room = let nextState = next room
                   in if nextState == room
                      then room
                      else stabilise nextState

occupied :: Room -> Int
occupied = sum . V.map (V.foldl (\acc tile -> if tile == Chair True then acc + 1 else acc) 0)

answer1 :: Room -> Int
answer1 = occupied . stabilise

neighbors2 :: (Int, Int) -> Room -> Int
neighbors2 (x, y) room = sum $ map (f (x, y)) [(\x -> x - 1, \x -> x - 1), (id, \x -> x - 1), ((+ 1), \x -> x - 1), (\x -> x - 1, id), ((+ 1), id), (\x -> x - 1, (+ 1)), (id, (+ 1)), ((+ 1), (+ 1))]
  where f (x, y) (xfunc, yfunc) = let newX = xfunc x
                                      newY = yfunc y
                                      width = V.length $ V.head room
                                      len = V.length room
                                      tile = room V.! newY V.! newX
                                   in if not (newX < 0 || newX >= width || newY < 0 || newY>= len)
                                         then if tile /= Floor && tile == Chair True
                                                 then 1
                                                 else 0
                                         else f (newX, newY) (xfunc, yfunc)

answer2 :: Room -> Int
answer2 x = 0--occupied . stabilise 5 neighbors2
