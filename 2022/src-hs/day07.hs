{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

import Data.List (find, groupBy)
import Data.Maybe (fromJust)

-- I really need optics

type Name = String

type Parent = File

type Size = Int

data File = Directory Name Parent [File] | File Name Size
  deriving (Eq, Show)

getName :: File -> Name
getName (Directory name _ _) = name
getName (File name _) = name

getChild :: Name -> File -> Maybe File
getChild name (Directory _ _ children) = find ((== name) . getName) children

nothingFile :: File
nothingFile = File "Null" 0

root :: File -> File
root d
  | parent d == nothingFile = d
  | otherwise = root $ parent d

parent :: File -> File
parent (Directory _ p _) = p

isRoot :: File -> Bool
isRoot x = parent x == nothingFile

parseLsOutput :: File -> String -> File
parseLsOutput dir s =
  let [metaData, name] = words s
   in if metaData == "dir"
        then Directory name dir []
        else File name $ read metaData

size :: File -> Int
size (Directory _ _ files) = sum $ map size files
size (File _ size) = size

move :: File -> String -> File
move wd new
  | new == ".." = parent wd
  | new == "/" = root wd
  | otherwise = fromJust $ getChild new wd

parseInput :: String -> File
parseInput = f (Directory "/" nothingFile []) . chunk
  where
    chunk :: String -> [[String]]
    chunk = groupBy (\x y -> (head x == '$' && head y == '$') || (head x /= '$' && head y /= '$')) . lines

    f :: File -> [[String]] -> File
    f dir (comms : lists : _) =
      let cd = foldl move dir comms
          d = addChildren dir $ map (parseLsOutput dir) lists
       in if isRoot dir then d else replaceChild (parent dir) dir d

    addChildren :: File -> [File] -> File
    addChildren dir children = let (Directory name parent _) = dir in Directory name parent children

replaceChild :: File -> File -> File -> File
replaceChild par old new = if isRoot par then newPar else replaceChild (parent par) par newPar
  where
    newPar = let (Directory name parent children) = par in Directory name parent $ update children old new

    update :: [File] -> File -> File -> [File]
    update [] _ _ = []
    update (x : xs) old new = if x == old then new : xs else x : update xs old new

printDirs :: File -> IO ()
printDirs (Directory name _  children) = putStrLn ("Directory " ++ name) >> mapM_ printDirs children >> putStrLn ""
printDirs (File name _) = putStrLn ("File " ++ name)

main :: IO ()
main = do
  tree <- parseInput <$> getContents
  printDirs tree
