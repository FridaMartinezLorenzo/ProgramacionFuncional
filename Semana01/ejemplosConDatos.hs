igual2 :: Int -> Bool --True or False
igual2 x = (x==2)

pegarCad :: [Char] -> [Char]
pegarCad x = "hola que tal? " ++ x ++ " Me invitas un cafe?"

inicioCad :: String -> Char 
inicioCad cad = if cad =="" then error "Cadena vacia" else 'a'
mul2 :: Num a => a -> a
mul2 x = x*2

contar :: String -> (Int, Char, String)
contar st | st=="" = error "Cadena vacia"
          | otherwise =  (length st, head st, tail st)

pegar :: ([a],[a]) -> [a]
pegar (st1, st2) = st1 ++ st2

-- Curried form:
pegar2 st1 st2 = st1 ++ st2

