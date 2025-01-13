import Data.List

colocar a ls = [(fst x)++[a]++(snd x) | x <- zip (inits ls) (tails ls)]

permIns [] = [[]]
permIns (a:bs) = concat (map (colocar a) [ xs | xs <- permIns bs])