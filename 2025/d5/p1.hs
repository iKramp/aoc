import Data.List
import Data.Char
import Data.String
import Debug.Trace
import Data.Bifunctor

main = interact 
    $ show 
    . length
    . (\(ranges, nums) -> 
        filter (\n -> any (\(l, r) -> n >= l && n <= r) ranges) nums
    )
    . first (map (bimap (read :: String -> Int) (read :: String -> Int)))
    . first (map ((second (drop 1)) . span (/= '-')))
    . second (map (read :: String -> Int))
    . second (drop 1)
    . span (/= [])
    . unfoldr (\s -> if null s then Nothing else Just (bimap id (drop 1) (span (/= '\n') s)))
