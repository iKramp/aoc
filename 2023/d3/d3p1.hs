import Data.Char
import Data.List
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

getSymbolIndexes :: Int -> [String] -> [(Int, Int)]
getSymbolIndexes _ [] = []
getSymbolIndexes n (e : xe) = map (,n) (getSymbolIndexRows e) ++ getSymbolIndexes (n + 1) xe

getNumIndexes :: Int -> [String] -> [((Int, Int), Int)]
getNumIndexes _ [] = []
getNumIndexes n (e : xe) = map (,n) (combineNumIndexes (-2) . getNumberIndexRows $ e) ++ getNumIndexes (n + 1) xe

getSymbolIndexRows :: String -> [Int]
getSymbolIndexRows a = filterReturnIndex a (\x -> (x /= '.') && (x `notElem` ['0'..'9'])) 0

getNumberIndexRows :: String -> [Int]
getNumberIndexRows a = filterReturnIndex a (`elem` ['0' .. '9']) 0

combineNumIndexes :: Int -> [Int] -> [(Int, Int)]
combineNumIndexes (-2) [] = []
combineNumIndexes (-2) [e] = [(e, e)]
combineNumIndexes (-2) (e : [f]) =
  if e + 1 == f
    then [(e, f)]
    else [(e, e), (f, f)]
combineNumIndexes (-2) (e : f : xe) =
  if e + 1 == f
    then combineNumIndexes e (f : xe)
    else (e, e) : combineNumIndexes (-2) (f : xe)
combineNumIndexes n (e : [f]) =
  if e + 1 == f
    then [(n, f)]
    else [(n, e), (f, f)]
combineNumIndexes n (e : f : xe) =
  if e + 1 == f
    then combineNumIndexes n (f : xe)
    else (n, e) : combineNumIndexes (-2) (f : xe)

filterReturnIndex :: String -> (Char -> Bool) -> Int -> [Int]
filterReturnIndex [] _ _ = []
filterReturnIndex (e : xe) pred i
  | pred e = i : filterReturnIndex xe pred (i + 1)
  | otherwise = filterReturnIndex xe pred (i + 1)

filterNumIndexes :: [((Int, Int), Int)] -> [(Int, Int)] -> [((Int, Int), Int)]
filterNumIndexes numIndexes symbolIndexes = filter (\((ix1, ix2), iy) -> any (\x -> any (\y -> (x, y) `elem` symbolIndexes) [(iy - 1) .. (iy + 1)]) [(ix1 - 1) .. (ix2 + 1)]) numIndexes

getNums :: [[Char]] -> [((Int, Int), Int)] -> [[Char]]
getNums _ [] = []
getNums a (e : xe) = getNum a e : getNums a xe

getNum :: [[Char]] -> ((Int, Int), Int) -> [Char]
getNum a ((ix1, ix2), iy) = concatMap (\x -> [a !! iy !! x]) [ix1..ix2]

toNum :: [Char] -> Int
toNum = foldl (\acc x -> acc * 10 + digitToInt x) 0


solveGrid :: [[Char]] -> Int
solveGrid a =
  let symbolCoords = getSymbolIndexes 0 a
      numberCoords = getNumIndexes 0 a
   in sum $ map toNum . getNums a $ filterNumIndexes numberCoords symbolCoords

main = interact $ show . solveGrid . splitStr '\n'
