import Data.List
import Data.Char
import Data.String
import Debug.Trace
import Data.Bifunctor

main = interact 
    $ show 
    . snd
    . foldl (\(acc_pos, acc_cnt) x -> (acc_pos + x, if rem (acc_pos + x) 100 == 0 then acc_cnt + 1 else acc_cnt)) (50, 0)
    . concat 
    . map (
        (\n -> if n < 0 then replicate (abs n) (-1) else replicate n 1)
        . (\s -> if head s == 'L' then -(read (tail s) :: Int) else (read (tail s) :: Int))
    ) 
    . filter (\x -> length x /= 0)
    . (unfoldr (\s -> if null s then Nothing else Just (bimap (\x -> x) (drop 1) (span (/= '\n') s))))
