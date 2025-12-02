import Data.List
import Data.Char
import Data.String
import Debug.Trace
import Data.Bifunctor

main = interact 
    $ show 
    . sum
    . map (read . fst) 
    . filter (\(str, lens) -> any (\len -> 
        all 
            (== (take len str))
            (unfoldr (\s -> if null s then Nothing else Just (take len s, drop len s)) str)
    ) lens)
    . map (
        (\x -> (
                x,
                filter 
                    (\len -> mod (length x) len == 0) 
                    (enumFromTo 1 (length x - 1))
        )) 
        . show
    ) 
    . concat
    . map (\(s, e) -> enumFromTo s e)
    . map (
        bimap 
            (read :: String -> Int)
            (read . filter (/= '-')) 
        . span (/= '-')
    ) 
    . (unfoldr (\s -> if null s then Nothing else Just (bimap (\x -> x) (drop 1) (span (/= ',') s))))
    . filter (/= '\n')
