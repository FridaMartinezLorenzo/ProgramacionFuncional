-- import Data.Set

subsets [] = [[]]
-- subsets (a:bs) = subsets bs ++ map (a:) (subset bs)
subsets (a:bs) =  ls++ map (a:) ls
	where
		ls = subsets bs

cartesiano m n = [(x,y) | x <- m, y <-n]
cartesianoCat m n = [(x,y) | x <- m, y <-n]