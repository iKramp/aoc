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

sortHands :: String -> String -> Ordering
sortHands a b = 
    let 
        aFiveOfKind = fiveOfKind a
        bFiveOfKind = fiveOfKind b
    in
        EQ

fiveOfKind :: String -> Bool
fiveOfKind hand = 
    let
        card = head hand
    in
        all (== card) hand

fourOfKind :: String -> Bool
fourOfKind hand = 
    let
        card = head hand
    in
        length (filter (== card) hand) == 4


main = interact $ show
