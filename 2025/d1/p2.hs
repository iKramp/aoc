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

dirNumToNum :: String -> Int
dirNumToNum s
    | head s == 'L' = -(read (tail s) :: Int)
    | head s == 'R' = read (tail s) :: Int
    | otherwise = error "Invalid direction"

--pos res_sum chunks
solve :: Int -> Int -> [Int] -> Int
solve _ res_sum [] = res_sum
solve pos_sum res_sum (this_pos : rest)
    | rem (this_pos + pos_sum) 100 == 0 = solve (pos_sum + this_pos) (res_sum + 1) rest
    | otherwise = solve (pos_sum + this_pos) res_sum rest

splitChunk :: Int -> [Int]
splitChunk 0 = []
splitChunk n
    | n < 0 = (-1) : splitChunk (n + 1)
    | otherwise = 1 : splitChunk (n - 1)


main = interact $ show . solve 50 0 . concat . map (splitChunk . dirNumToNum) . splitStr '\n'
