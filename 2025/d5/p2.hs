import Data.List
import Data.Char
import Data.String
import Debug.Trace
import Data.Bifunctor
import GHC.Exts

main = interact 
    $ show 
    . sum
    . map (\(l, r) -> r - l)
    . foldl (\((acc_hd_l, acc_hd_r) : acc_rst) (range_l, range_r) ->
        if range_l <= acc_hd_r then
            (acc_hd_l, max acc_hd_r range_r) : acc_rst
        else
            (range_l, range_r) : (acc_hd_l, acc_hd_r) : acc_rst
    ) ((0, 0) : [])
    . map (second (+1))
    . sort
    . map (bimap (read :: String -> Int) (read :: String -> Int))
    . map ((second (drop 1)) . span (/= '-'))
    . fst
    . span (/= [])
    . unfoldr (\s -> if null s then Nothing else Just (bimap id (drop 1) (span (/= '\n') s)))
