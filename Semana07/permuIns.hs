import Data.List

colocar a ls = [(fst x)++[a]++(snd x) | x <- zip (inits ls) (tails ls)]

permIns [] = [[]]
permIns (a:bs) = concat (map (colocar a) [ xs | xs <- permIns bs])

permInsOrd [] = [[]]
permInsOrd (a:bs) = concat (map (colocar a)
	   [ xs | xs <- (filter ordenada (permInsOrd bs))])

permInsOrdenar ls = head (filter ordenada (permIns ls))

permInsOrdenar2 ls = head (filter ordenada (permInsOrd ls))

ordenada [] = True
ordenada [a] = True
ordenada (a:b:bs) = (a<=b) && (ordenada (b:bs))

-- permsIns []
-- [[]]

-- [1]
-- concat [[1]]
-- [[1]]

-- [1,2]
-- [[[2,1]],[[1,2]]]

-- [1,2,3]
-- [[[3,2,1]],[[3,1,2]]]
-- [[[1,2,3]],[[1,3,2]]]
-- [[[2,1,3]],[[2,3,1]]]