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

calculateUsed :: ([Int], [[(Int, Int, Int)]]) -> [(Int, Int)]
calculateUsed (_, []) = trace "empty" []
calculateUsed ([], _) = trace "empty" []
calculateUsed (startAcc, list) = foldl (\acc rules -> trace (show acc) concatMap (mapToNextLevel rules) acc) (makeSeedRanges startAcc) list

mapToNextLevel :: [(Int, Int, Int)] -> (Int, Int) -> [(Int, Int)]
mapToNextLevel [] n = [n]
mapToNextLevel ((destination, source, length) : xe) (start_range, end_range)
    | start_range >= source && end_range <= source + length - 1 = trace ("Found map from " ++ show source ++ " to " ++ show destination) [(destination + (start_range - source), destination + (end_range - source))]
    | start_range < source && end_range >= source = mapToNextLevel ((destination, source, length) : xe) (start_range, source - 1) ++ mapToNextLevel ((destination, source, length) : xe) (source, end_range)
    | start_range >= source && start_range <= source + length - 1 = mapToNextLevel ((destination, source, length) : xe) (start_range, source + length - 1) ++ mapToNextLevel ((destination, source, length) : xe) (source + length, end_range)
    | otherwise = mapToNextLevel xe (start_range, end_range)

makeSeedRanges :: [Int] -> [(Int, Int)]
makeSeedRanges [] = []
makeSeedRanges (a : b : xe) = (a, a + b - 1) : makeSeedRanges xe

main = interact $ show . minimum . map fst . calculateUsed . makeDataStructure . cleanData
