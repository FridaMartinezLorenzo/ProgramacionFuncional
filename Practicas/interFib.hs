-- Definición de la función interFib
interFib :: Int -> Integer
interFib 0 = 1
interFib 1 = 1
interFib 2 = 1
interFib n = interFib (n - 1) - interFib (n - 3)

-- Función para encontrar el primer índice m en que interFib m > 100000000
buscarIndice :: Int
buscarIndice = head [m | m <- [0..], interFib m > 100000000]

-- Resultado de interFib en dicho índice
resultado :: Integer
resultado = interFib buscarIndice

-- Definición de una lista infinita para interFib
interFibList :: [Integer]
interFibList = 1 : 1 : 1 : zipWith3 (\a b c -> a - c) (tail interFibList) interFibList (drop 2 interFibList)

-- Función para encontrar el índice del primer valor en interFibList que sea mayor que 100 millones
buscarIndiceOpt :: Int
buscarIndiceOpt = length (takeWhile (<= 100000000) interFibList)

-- Resultado de interFib en dicho índice
resultadoOpt :: Integer
resultadoOpt = interFibList !! buscarIndiceOpt
