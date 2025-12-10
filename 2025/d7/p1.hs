import Data.List
import Data.Char
import Data.String
import Debug.Trace
import Data.Bifunctor

main = interact 
    $ show
    . unfoldr (\s -> if null s then Nothing else Just (bimap id (drop 1) (span (/= '\n') s)))
