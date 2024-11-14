import Data.List
import Data.Char
import Data.String

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

--remove everything until :<space>
removeHead :: String -> String
removeHead [] = []
removeHead (e : f : xe)
  | e == ':' = xe
  | otherwise = removeHead (f : xe)

--turn list of lists into list of tuples
combineLists :: [[a]] -> [(a, a)]
combineLists = map (\ e -> (head e, last e))

findMatching :: ([Int], [Int]) -> [Int]
findMatching ([], _) = []
findMatching (e : xe, a) = if e `elem` a then e : findMatching (xe, a) else findMatching (xe, a)

getCardScore :: [Int] -> Int
getCardScore [] = 0
getCardScore l = 2 ^ (length l - 1)


main = interact $ show . sum . map (getCardScore . findMatching) . combineLists . (map (map (map (read :: String -> Int) . splitStr ' ') . (splitStr '|' . removeHead)) . splitStr '\n')

