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

addCardNumbers :: Int -> (Int, Int)
addCardNumbers n = (n, 1)

addCopiedCards :: [(Int, Int)] -> [(Int, Int)]
addCopiedCards [] = []
addCopiedCards ((card, num) : xl) = (card, num) : addCopiedCards (addCopies card num xl)

addCopies :: Int -> Int -> [(Int, Int)] -> [(Int, Int)]
addCopies 0 _ l = l
addCopies _ _ [] = []
addCopies n copies ((card, num) : xl) = (card, num + copies) : addCopies (n - 1) copies xl

getNumCards :: (Int, Int) -> Int
getNumCards (_, num) = num


main = interact $ show . sum . map getNumCards . addCopiedCards . map (addCardNumbers . length . findMatching) . combineLists . (map (map (map (read :: String -> Int) . splitStr ' ') . (splitStr '|' . removeHead)) . splitStr '\n')

