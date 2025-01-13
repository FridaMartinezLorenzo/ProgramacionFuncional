-- Definición de tipos
data AG = Ar [AG] | H Int deriving Show
data AGN = A Int [AGN] | Ho Int deriving Show
data AGNS = As String [AGNS] | Hi String deriving Show
data I_String = I Int | S String deriving Show
data IString = Int * String 

-- Ejemplos
eje1 = H 1
eje2 = Ar [H 2, H 3]
eje3 = Ar [H 2, Ar [H 3, H 4],
            Ar [H 7, Ar [H 8, H 9, H 10]]]

eje11 = Ho 1
eje22 = A 3 [Ho 2, Ho 3]
eje33 = A 4 [Ho 2, A 7 [Ho 3, Ho 4], A 5 [Ho 7, A 6 [Ho 8, Ho 9, Ho 10]]]
eje44 = A 3 [Ho 4, A 6 [Ho 5, Ho 8], Ho 7]

eje111 = Hi "1"
eje222 = As "Hola" [Hi "Mucho", Hi "Gusto"]
eje333 = As "Bais" [Hi "Bonjour", As "Chao" [Hi "Hello", Hi "Toy"], As "Cansao" [Hi "AHHHHH", As "Help" [Hi "Me", Hi "Idont", Hi "undestand"]]]


-- Es una suma de tipos
ejemplo1 = (2, "Cheetos")

-- Contar hojas para el tipo AG
contarHojas :: AG -> Int
contarHojas (H n) = 1
contarHojas (Ar ls) = sum (map contarHojas ls)

-- Contar hojas para el tipo AGN
contarHojasA :: AGN -> Int
contarHojasA (Ho n) = 1
contarHojasA (A n ls) = 1 + sum (map contarHojasA ls)

-- 
aplicarFuncionNodosA f (Ho n) = Ho (f n)
aplicarFuncionNodosA f (A n ls) = A (f n) t
                       where
                          t = map (aplicarFuncionNodosA f) ls

-- Sumar hojas para el tipo AG
sumaHojas :: AG -> Int
sumaHojas (H n) = n
sumaHojas (Ar ls) = sum (map sumaHojas ls)

-- Sumar hojas para el tipo AGN
sumaHojasA :: AGN -> Int
sumaHojasA (Ho n) = n
sumaHojasA (A n ls) = n + sum (map sumaHojasA ls)

-- Pegar Hojas del arbol tipo cadenas
concatHojas (Hi n) = n
concatHojas (As n ls ) = n ++ concat(map concatHojas ls)
-- Multiplicar hojas para el tipo AG
mulHojas :: AG -> Int
mulHojas (H n) = n
mulHojas (Ar ls) = product (map mulHojas ls)

-- Altura para el tipo AG
alturaAg :: AG -> Int
alturaAg (H n) = 0
alturaAg (Ar ls) = 1 + maximum (map alturaAg ls)

-- Altura para el tipo AGN
alturaAGN :: AGN -> Int
alturaAGN (Ho n) = 0
alturaAGN (A n ls) = 1 +  maximum (map alturaAGN ls)


-- Max de lista
maxList [] = -1000
maxList [a] = a
maxList (a:b:ls) = max (max a b) (maxList (b:ls))

-- 2
-- | \  \
-- 2 3  4

