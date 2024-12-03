import Data.List
import Data.Char
import Data.String
import Debug.Trace
import GHC.Float (int2Float)

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

filterInput :: String -> [[Int]]
filterInput = map (map read . splitStr '\n') . splitStr ':' . filter (\x -> x == ':' || isDigit x || x == '\n')

groupInput :: [a] -> (a, a)
groupInput [a, b] = (a, b)

groupByPairs :: ([a], [a]) -> [(a, a)]
groupByPairs (a, b) = zip a b

findZeroes :: (Int, Int) -> (Float, Float)
findZeroes (t, d) =
    let dis = sqrt $ int2Float (t * t - 4 * d)
        x1 = (int2Float (-t) + dis) / (-2.0)
        x2 = (int2Float (-t) - dis) / (-2)
    in
        (x1 + 0.000001, x2 - 0.000001)

roundTogether :: (Float, Float) -> (Int, Int)
roundTogether (a, b) = (ceiling a, floor b)

sumTogether :: (Int, Int) -> Int
sumTogether (a, b) = b - a + 1

main = interact $ show . product . map (sumTogether . roundTogether . findZeroes) . groupByPairs . groupInput . filterInput
