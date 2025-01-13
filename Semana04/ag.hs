import Data.Tree
data AG = Ar [AG] | H Int deriving Show

data AGN = A Int [AGN] | Ho Int deriving Show

data AGNS = As String [AGNS] | Hi String deriving Show  

data I_String = I Int | S String deriving Show


data IString = Int * String
ejemplo1 = (2,"jpña hola piña colada, alias norma")


ej1 = Hi "1unouno"
ej2 = As "Hola" [Hi "2", Hi "33344"]
ej3 = As "adios" [Hi  "fasf2", As "hojo" [Hi "cad3", Hi "cad4"],
     As "sisste" [Hi "faf7", As "jp jp jp"  [Hi  "8fast", Hi "9dd", Hi "10"]]]



eje1 = H 1
eje2 = Ar [H 2, H 3]
eje3 = Ar [H 2, Ar [H 3, H 4],
     Ar [H 7, Ar [H 8, H 9, H 10]]]


eje11 = Ho 1

eje22 = A 3 [Ho 2, Ho 3]

eje33 = A 4 [Ho 2, A 7 [Ho 3, Ho 4],
     A 5 [Ho 7, A 6 [Ho 8, Ho 9, Ho 10]]]

eje44 = A 4 [eje33, eje33, eje22]
--- Catamorfismo

contarHojas (H n) = 1 
contarHojas (Ar ls) = sum (map contarHojas ls)

sumaHojas (H n) = n 
sumaHojas (Ar ls) = sum (map sumaHojas ls)

contarNodosA (Ho n) = 1
contarNodosA (A n ls) = 1 + sum (map contarNodosA ls)

aplicarFuncionNodosA f (Ho n) = Ho (f n)
aplicarFuncionNodosA f (A n ls) = A (f n) t
                 where
                    t = map (aplicarFuncionNodosA f) ls

sumaHojasA (Ho n) = n 
sumaHojasA (A n ls) = n + sum (map sumaHojasA ls)

opegarHojasA (Hi n) = n 
pegarHojasA (As n ls) = n ++ concat (map pegarHojasA ls)

mulHojas (H n) = n 
mulHojas (Ar ls) = product (map mulHojas ls)

maximoAg (H n) = n
maximoAg (Ar ls) = maxList (map maximoAg ls) 


alturaAg (H n) = 0
alturaAg (Ar ls) = 1 + maxList (map alturaAg ls) 

maxList [] = (-1000) 
maxList [a] =  a
maxList (a:b:ls) = max (max a b) (maxList (b:ls))

--  map contarHojas ..(
--     *Ar
--   /  |  \
-- 2   *Ar    *Ar
--     / \    / \
--     3 4    7  * Ar
--              / | \ 
--              8 9 10)

--     A 1
--   /  |  \
-- 2   A 2   A 4
--     / \    / \
--     3 4    7  A 3
--              / | \ 
--              8 9 10 	     
-- 

--  2
-- | \ \
-- 2 3 4
