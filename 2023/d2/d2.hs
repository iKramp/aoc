import Data.List
import Data.String
import Data.Char

splitStr :: Char -> String -> [String]
splitStr _ [] = []
splitStr a [e]
    | a == e = []
    | otherwise = [[e]]
splitStr a (e : f : xe)
    | a == e = splitStr a (f : xe)
    | a == f = (e : []) : splitStr a xe
    | otherwise = (e : first) : rest
    where
        (first : rest) = splitStr a (f : xe)

count :: [String] -> (Int, Int, Int)
count [] = (0, 0, 0)
count (e : c : xe) = 
    let 
    (r, g, b) = count xe
    num = foldl (\acc x -> acc * 10 + digitToInt x) 0 e
    in
    case c of
        "b" -> (r, g, b `max` num)
        "g" -> (r, g `max` num, b)
        "d" -> (r `max` num, g, b)

check :: (Int, Int, Int) -> Int
check (r, g, b) = r * g * b

main = interact $ show . sum . map check . map count . map (\x -> tail . splitStr ' ' $ x) .
    splitStr '\n' . filter (\x -> isDigit x || x == ' ' || x == '\n' || x == 'b' || x == 'g' || x == 'd')
