cubos :: Num a => [a] -> [a]
cubos xs = map (\x -> x^3) xs

cubosLista :: [[Int]] -> [[Int]]
cubosLista = map (map (\x -> x^3))
