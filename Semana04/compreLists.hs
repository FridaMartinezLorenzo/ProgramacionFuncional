-- from Data.List import delete

delete a [] = []
delete a (b:ls) | a==b = ls
delete a (b:ls) | a/=b = (b:delete a ls)

-- Mètodo de extracciòn
perms [] = [[]]
perms (a:bs) = [ (x:xs) | x<-(a:bs), xs <- perms (delete x (a:bs))]

perms2 [] = [[]]
perms2 (a:bs) = [ (x:xs) | x<- [minimum (a:bs)], xs <- perms2 (delete x (a:bs))]

ordenamientoMaudi ls = filter ordenada (perms ls)
ordenamiento ls = filter ordenada (perms2 ls)

ordenada [] = True
ordenada [a] = True
ordenada (a:b:ls) = (a<=b) && (ordenada (b:ls)) 

-- mètodo de inserciòn...

-- [1,2,3]

-- []
-- [1],[2],[3]

-- [2,1],[1,2]

-- [3,2,1]
-- [2,3,1]
-- [2,1,3]
-- [3,1,2]
-- [1,3,2]
-- [1,2,3]

-- [1,3],

-- [3,1]

-- [2,3],[3,2]




-- m x = 1/0
-- h(x) = (x, 1/0, m x)

-- f x = (x, x**2)
-- hg x = x+y
--   where
-- 	y = x/0

-- [1,2,3]
-- 1, borrar (1,[1,2,3]) [2,3], permutaciones [1:[2,3],1:[3,2]]
-- 2, [1,3]  [2:[1,3],2:[3,1]]
-- 3,  [1,2] [3:[1,2],3:[2,1]]

-- [2,3]
-- 2  [3] con permutaciones [[2,3]]
-- 3  [2] con permutaciones [[3,2]]

-- [3]
-- 3 [] [[]]
-- 3:[] --> [[3]]
-- [2]
-- 2 [] [[]]
-- 2:[] --> [[2]]

