-- Definición de un árbol binario
data Arbol = Nodo Arbol Arbol | Hoja Int
  deriving (Show)

-- Función que busca todos los elementos pares en el árbol
elementosPares :: Arbol -> [Int]
elementosPares (Hoja x)
  | even x    = [x]    -- Si es par, se agrega a la lista
  | otherwise = []     -- Si no es par, se ignora
elementosPares (Nodo izq der) =
  elementosPares izq ++ elementosPares der  -- Recorre ambos subárboles

-- Definición de un árbol general
data AGN = A Int [AGN] | Ho Int
  deriving (Show)

-- Función que busca todos los elementos pares en el árbol general
elementosPares1 :: AGN -> [Int]
elementosPares1 (Ho x)
  | even x    = [x]      -- Si es par, se agrega a la lista
  | otherwise = []       -- Si no es par, se ignora
elementosPares1 (A x subarboles) =
  (if even x then [x] else []) ++ concatMap elementosPares1 subarboles

-- Función para reemplazar los valores pares en el árbol con 0
sustituirParesAGN :: AGN -> AGN
sustituirParesAGN (Ho x)
  | even x    = Ho 0        -- Si el valor es par, lo reemplazamos con 0
  | otherwise = Ho x        -- Si no, lo dejamos igual
sustituirParesAGN (A x subarboles) =
  A (if even x then 0 else x) (map sustituirParesAGN subarboles)


-- Ejemplo de un árbol general
arbolEjemplo :: AGN
arbolEjemplo = A 3 [Ho 4, A 6 [Ho 5, Ho 8], Ho 7]

-- Resultado esperado: [4, 6, 8]
resultado = elementosPares1 arbolEjemplo