import Data.List
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
            case op of
                '+' -> acc + foldl1 (+) (nums !! opIdx)
                '*' -> acc + foldl1 (*) (nums !! opIdx)
                _ -> acc
    ) 0 len)
    . (\(x, ops) -> (x, ops, enumFromTo 0 ((length ops) - 1)))
    . second (filter (/= ' '))
    . first (map (map (read :: String -> Int)))
    . first (map (filter (/= "") . map (filter (/= ' '))))
    . first (map transpose)
    . first (transpose)
    . (\(nums, ops, lens) -> (map (\num_arr -> 
        snd ((foldl (\(len_before_acc :: Int, arr_acc :: [String]) (new_len :: Int) -> 
            (len_before_acc + new_len + 1, arr_acc ++ [take new_len (drop len_before_acc num_arr)])
        ) (0, []) lens))
    ) nums, ops))
    . (\(nums, ops) -> (nums, ops, (drop 1) (map length (
        unfoldr (\s -> if null s then Nothing else Just (bimap id (drop 1) (span (== ' ') s))) ops
    ))))
    . (\x -> (take (length x - 1) x, x !! (length x - 1)))
    . unfoldr (\s -> if null s then Nothing else Just (bimap id (drop 1) (span (/= '\n') s)))
