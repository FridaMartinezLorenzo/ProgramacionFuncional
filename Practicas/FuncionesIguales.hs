-- Definición de funciones para las propiedades
f x = x + 1
g x = x * 2
h x = x - 3
q x = x > 2

-- Listas para prueba
ls = [1, 2, 3]
ms = [4, 5, 6]

-- Variables para prueba
m = 5
n = 10
expresion = True

-- Propiedad a) (f . g) . h = f . (g . h)
propA1 = ((f . g) . h) 5
propA2 = (f . (g . h)) 5
resultadoA = propA1 == propA2

-- Propiedad b) map (f . g) ls = map f (map g ls)
propB1 = map (f . g) ls
propB2 = map f (map g ls)
resultadoB = propB1 == propB2

-- Propiedad c) map f (ls ++ ms) = (map f ls) ++ (map f ms)
propC1 = map f (ls ++ ms)
propC2 = (map f ls) ++ (map f ms)
resultadoC = propC1 == propC2

-- Propiedad d) (f $ if expresion then m else n) = if expresion then f m else f n
propD1 = f $ if expresion then m else n
propD2 = if expresion then f m else f n
resultadoD = propD1 == propD2

-- Propiedad e) [f a | a <- ls] = map f ls
propE1 = [f a | a <- ls]
propE2 = map f ls
resultadoE = propE1 == propE2

-- Propiedad f) filter q ls = [a | a <- ls, q a]
propF1 = filter q ls
propF2 = [a | a <- ls, q a]
resultadoF = propF1 == propF2
