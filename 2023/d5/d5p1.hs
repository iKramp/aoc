import Data.List
import Data.Char
import Data.String
import Debug.Trace

chunks :: Int -> [a] -> [[a]]
chunks _ [] = []
chunks n l
  | n > 0 = take n l : chunks n (drop n l)
  | otherwise = error "Negative or zero n"

splitStr :: Char -> String -> [String]
splitStr _ [] = []
splitStr a [e]
  | a == e = []
  | otherwise = [[e]]
splitStr a (e : f : xe)
  | a == e = splitStr a (f : xe)
  | a == f = [e] : splitStr a xe
  | otherwise = (e : first) : rest
  where
    (first : rest) = splitStr a (f : xe)


makeDataStructure :: String -> ([Int], [[(Int, Int, Int)]])
makeDataStructure input = 
    let entries = map (splitStr ' ') . splitEntries $ input
    in
        (map read . head $ entries, map groupEntries . tail $ entries)

splitEntries :: String -> [String]
splitEntries = splitStr ':'

groupEntries :: [String] -> [(Int, Int, Int)]
groupEntries = map (\[a, b, c] -> (read a, read b, read c)) . chunks 3

cleanData :: String -> String
cleanData = filter (\x -> isDigit x || x == ' ' || x == ':') . map (\x -> if x == '\n' then ' ' else x)

calculateUsed :: ([Int], [[(Int, Int, Int)]]) -> [Int]
calculateUsed (_, []) = trace "empty" []
calculateUsed ([], _) = trace "empty" []
calculateUsed (startAcc, list) = foldl (\acc rules -> trace (show acc) map (mapToNextLevel rules) acc) startAcc list

mapToNextLevel :: [(Int, Int, Int)] -> Int -> Int
mapToNextLevel [] n = n
mapToNextLevel ((destination, source, length) : xe) n
    | n >= source && n < source + length = trace ("Found map from " ++ show source ++ " to " ++ show destination) destination + (n - source)
    | otherwise = mapToNextLevel xe n

main = interact $ show . minimum . calculateUsed . makeDataStructure . cleanData
