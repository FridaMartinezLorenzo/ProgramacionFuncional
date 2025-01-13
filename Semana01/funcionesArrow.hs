
cuadrado :: Int -> Int
cuadrado x = x*x

sumaUno :: Int -> Int
sumaUno y = y + 1


-- valAbsoluto :: (Ord p, Num p) => p -> p

valAbsoluto :: Int -> Int
valAbsoluto a = if a > 0 then a else (-a)

compMasUnoCuadrado x = sumaUno (cuadrado x)
compCuadradoMasUno x = cuadrado (sumaUno x)