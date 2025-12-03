import Data.List
import Data.Char
import Data.String
import Debug.Trace
import Data.Bifunctor

main = interact 
    $ show 
    . sum
    . map ((read :: String -> Int) . reverse . snd)
    . (\(input :: [(String, String)]) -> 
        foldl (\(acc :: [(String, String)]) (num :: Int) ->
                map (\(curr_seq :: String, num_buf :: String) -> 
                    ((\(pos :: Int, num :: Char, _ :: Int) -> (drop (pos + 1) curr_seq, num : num_buf))
                    . (foldl (
                        \(acc_pos :: Int, acc_max :: Char, acc_curr_pos :: Int) elem -> 
                            if elem > acc_max then 
                                (acc_curr_pos, elem, acc_curr_pos + 1) 
                            else 
                                (acc_pos, acc_max, acc_curr_pos + 1)
                    ) (-1, '/', 0))
                    . take (length curr_seq - num)) curr_seq --remove last len_left, type is String
                ) acc
        ) input (reverse (enumFromTo 0 11))
    )
    . map (\str -> (str, [] :: String)) --(String, String)
    . (unfoldr (\s -> if null s then Nothing else Just (bimap (\x -> x) (drop 1) (span (/= '\n') s))))

