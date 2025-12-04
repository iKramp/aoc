import Data.List
import Data.Char
import Data.String
import Debug.Trace
import Data.Bifunctor

main = interact 
    $ show 
    . length
    . filter (== 'x')
    . concat
    . (\(arr :: [String], (rows :: [Int], cols :: [Int])) -> 
        foldl(\acc_arr_out iter ->
            foldl (\acc_arr_c row -> 
                foldl (\acc_arr col -> 
                    if (acc_arr !! row !! col == '.') then
                        acc_arr
                    else if (4 > (length (filter (== '@')
                        [
                            acc_arr !! (row + 1) !! (col + 1),
                            acc_arr !! (row + 1) !! (col + 0),
                            acc_arr !! (row + 1) !! (col - 1),
                            acc_arr !! (row + 0) !! (col - 1),
                            acc_arr !! (row - 1) !! (col - 1),
                            acc_arr !! (row - 1) !! (col + 0),
                            acc_arr !! (row - 1) !! (col + 1),
                            acc_arr !! (row + 0) !! (col + 1)
                        ]
                    ))) then 
                        (take row acc_arr) ++ ([
                            (take col (acc_arr !! row)) ++ ['x'] ++ (drop (col + 1) (acc_arr !! row))
                        ]) ++ (drop (row + 1) acc_arr)
                    else (
                        acc_arr 
                    )
                ) acc_arr_c cols
            ) acc_arr_out rows
        ) arr [1..100]
    )
    . (\arr -> (arr, (enumFromTo 1 (length arr - 2), enumFromTo 1 (length (head arr) - 2))))
    . (\(arr, n) -> [replicate n '.'] ++ arr ++ [replicate n '.'])
    . (\(arr :: [String]) -> (arr, length (head arr)))
    . map (\(x :: String) -> ('.' : x) ++ ['.'] )
    . unfoldr (\s -> if null s then Nothing else Just (bimap id (drop 1) (span (/= '\n') s)))
