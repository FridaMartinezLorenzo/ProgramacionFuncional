
permSel [] = [[]]
permSel (a:bs) = [(x:xs) | x <- (a:bs), xs <- permSel (delete x (a:bs))]

minSel [] = [[]]
minSel (a:bs) = [(x:xs) | x <- minimum [(a:bs)], xs <- minSel (delete x (a:bs))]

delete a [] = []
delete a (b:bs) = if a==b then bs else b:(delete a bs)

ordenada [] = True
ordenada [a] = True
ordenada (a:b:bs) = ((a<=b) && (ordenada (b:bs)))

ordenamientoMortal ls = filter ordenada (permSel ls)
ordenamientoNoTanMortal ls = filter ordenada (minSel ls)

permIns [] = []
permIns (a:bs) = (a:bs)

--  1,2,3,4
--- 1 <2
--  2,3,4
--- 2 < 3
--- 3 < 4

-- permSel [] - - - > []
-- permSel [1] -----> (x==1, xs <- [] ) [[1]]

-- -- delete 2

-- -- [3,2,1]? == []
-- -- (a:bs), a==3 bs==[2,1]