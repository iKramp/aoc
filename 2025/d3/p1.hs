import Data.List
import Data.Char
import Data.String
import Debug.Trace
import Data.Bifunctor

main = interact 
    $ show 
    . sum
    . map (read :: String -> Int)
    . map (\(largest, (_, num, _)) -> (head largest) : num : [])
    . map (\(largest, rest) -> (largest, 
        (\x ->
            (foldl (
                \(acc_pos, acc_max, acc_curr_pos) elem -> 
                    if elem > acc_max then 
                        (acc_curr_pos, elem, acc_curr_pos + 1) 
                    else 
                        (acc_pos, acc_max, acc_curr_pos + 1)
            ) (-1, '/', 0) x
        )) rest)
    )
    . map (\(seq, (pos, chr, _)) -> ((take 1 . drop pos) seq, drop (pos + 1) seq))
    . map ( 
        \y -> (snd y, 
        (\x ->
            (foldl (
                \(acc_pos, acc_max, acc_curr_pos) elem -> 
                    if elem > acc_max then 
                        (acc_curr_pos, elem, acc_curr_pos + 1) 
                    else 
                        (acc_pos, acc_max, acc_curr_pos + 1)
            ) (-1, '/', 0) (fst x)
        )) y)
    )
    . map (\x -> ((fst . splitAt (length x - 1)) x, x)) --remove last, type is (String, String)
    . (unfoldr (\s -> if null s then Nothing else Just (bimap (\x -> x) (drop 1) (span (/= '\n') s))))
