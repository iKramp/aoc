import Data.List
import Data.Char
import Data.String
import Debug.Trace
import Data.Bifunctor

main = interact 
    $ show
    . (\(nums, ops, len) -> foldl (
        \acc (opIdx) -> 
            let op = ops !! opIdx in
            case op !! 0 of
                '+' -> acc + foldl1 (+) (nums !! opIdx)
                '*' -> acc + foldl1 (*) (nums !! opIdx)
                _ -> acc
    ) 0 len)
    . (\(x, ops) -> (x, ops, enumFromTo 0 ((length ops) - 1)))
    . first transpose
    . first (map (map (read :: String -> Int)))
    . (\x -> (take (length x - 1) x, x !! (length x - 1)))
    . map (
        filter (/= "")
        . unfoldr (\s -> if null s then Nothing else Just (bimap id (drop 1) (span (/= ' ') s)))
    )
    . unfoldr (\s -> if null s then Nothing else Just (bimap id (drop 1) (span (/= '\n') s)))
