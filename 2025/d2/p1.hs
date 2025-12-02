import Data.List
import Data.Char
import Data.String
import Debug.Trace

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

toNumRange :: String -> (Int, Int)
toNumRange s = (read x, read y)
  where
    (x, (_ : y)) = span (/= '-') s

toNum :: String -> Int
toNum = read

expand :: (Int, Int) -> [Int]
expand (x, y)
  | x == y = [x]
  | otherwise = x : expand (x + 1, y)

isDouble :: String -> Bool
isDouble s = 
    let (first, second) = splitAt (div (length s) 2) s
    in first == second
    


main = interact $ show . sum . map toNum . filter isDouble . map show . concat . map (expand . toNumRange) . splitStr ',' . filter (/= '\n')
