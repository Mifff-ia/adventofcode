import Data.List (partition, nub)

type Signal = String

untilMarker :: Int -> Signal -> [String]
untilMarker size = takeWhile ((/= size) . length . nub) . scanl makeCode ""
  where
    makeCode :: String -> Char -> String
    makeCode s c = (if length s == size then tail s else s) ++ [c]

main :: IO ()
main = do
  signal <- getContents
  print $ length $ untilMarker 4 signal
  print $ length $ untilMarker 14 signal
