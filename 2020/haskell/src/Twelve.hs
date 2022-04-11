module Main where

import qualified Util as U
import qualified Data.Text as T
import qualified Data.Vector as V

data Movement = Absolute Cardinal Int | Turn Side Int | Forward Int

data Cardinal = North | West | South | East
instance Enum Cardinal where
  fromEnum North = 0
  fromEnum West = 1
  fromEnum South = 2
  fromEnum East = 3

  toEnum 0 = North
  toEnum 1 = West
  toEnum 2 = South
  toEnum 3 = East
  toEnum _ = error "Unsupported cardinal direction"

data Side = R | L
  deriving Eq

data Ship = Ship {
                 facing :: Cardinal,
                 vertDist :: Int,
                 horiDist :: Int
                 }

parser :: T.Text -> [Movement]
parser = map (\x -> whatMovement (T.head x) $ read $ T.unpack $ T.tail x) . T.lines

whatMovement :: Char -> Int -> Movement
whatMovement 'N' = Absolute North
whatMovement 'S' = Absolute South
whatMovement 'E' = Absolute East
whatMovement 'W' = Absolute West
whatMovement 'L' = Turn L
whatMovement 'R' = Turn R
whatMovement 'F' = Forward
whatMovement _   = error "Unsupported direction"


move :: Ship -> Movement -> Ship
move ship (Absolute direction steps) = case direction of
                                         North -> ship{vertDist = vertDist ship + steps}
                                         South -> ship{vertDist = vertDist ship - steps}
                                         East -> ship{horiDist = horiDist ship + steps}
                                         West -> ship{horiDist = horiDist ship - steps}
move ship (Turn direction degrees) = case direction of
                                       L -> ship {facing = toEnum $ (fromEnum (facing ship) + degrees `div` 90) `mod` 4}
                                       R -> ship {facing = toEnum $ (fromEnum (facing ship) - degrees `div` 90) `mod` 4}
move ship (Forward steps) = move ship (Absolute (facing ship) steps)

answer1 :: Ship -> [Movement] -> Int
answer1 ship = manhattan . foldl move ship

manhattan (Ship _ x y) = abs x + abs y

data Waypoint = Waypoint {
                vertPos :: Int,
                horiPos :: Int
                }


answer2 ship waypoint = manhattan . fst . foldl move2 (ship, waypoint)

move2 :: (Ship, Waypoint) -> Movement -> (Ship, Waypoint)
move2 (ship, waypoint) (Absolute direction steps) = (ship, case direction of
                                                             North -> waypoint{vertPos = vertPos waypoint + steps}
                                                             South -> waypoint{vertPos = vertPos waypoint - steps}
                                                             East -> waypoint{horiPos = horiPos waypoint + steps}
                                                             West -> waypoint{horiPos = horiPos waypoint - steps})
move2 (ship, waypoint) (Turn direction degrees) = let x = (degrees `div` 90) `mod` 4 in 
                                                      (ship, if x == 2
                                                                then waypoint{vertPos = - vertPos waypoint, horiPos = - horiPos waypoint}
                                                             else if (direction == L && x == 1) || (direction == R && x == 3)
                                                                then waypoint{vertPos = horiPos waypoint, horiPos = - vertPos waypoint}
                                                             else if (direction == R && x == 1) || (direction == L && x == 3)
                                                                then waypoint{vertPos = - horiPos waypoint, horiPos = vertPos waypoint}
                                                             else if x == 0 
                                                                then waypoint
                                                             else error "what happened?")
move2 (ship, waypoint) (Forward steps) = (ship{vertDist = vertDist ship + vertPos waypoint * steps,
                                               horiDist = horiDist ship + horiPos waypoint * steps}, waypoint)

main :: IO ()
main = U.generateMain 12 parser (answer1 (Ship East 0 0)) $ answer2 (Ship East 0 0) (Waypoint 1 10)
