-- Escribe una función que devuelva todos los pares ordenados (a,b) 
-- tales que a puede tomar un valor entero entre a1 y b1, b un valor entero entre a2+b2; y a+b = 17, con a1,b1,a2,b2 enteros positivos

paresOrdenados :: Int -> Int -> Int -> Int -> [(Int, Int)]
paresOrdenados a1 b1 a2 b2 = [(a, b) | a <- [a1..b1], b <- [a2..b2], a + b == 17]
