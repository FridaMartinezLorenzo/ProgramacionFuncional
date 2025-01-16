module Othello where
import System.IO (hFlush, stdout)
import Data.List (intercalate)
import Debug.Trace (trace)


import Data.Char
import Data.List
import Text.Read (readMaybe)

data TipoCuadrado = E | B | N deriving (Eq, Show) -- Empty, Blanco, Negro
data Jugador = JugadorBlanco | JugadorNegro deriving (Eq, Show)

-- Crear tablero 8x8
tablero :: [Int]
tablero = [10 * i + j | i <- [1..8], j <- [1..8]]

-- Tablero inicial
tableroInicial = [(11,E),(12,E),(13,E),(14,E),(15,E),(16,E),(17,E),(18,E),
                  (21,E),(22,E),(23,E),(24,E),(25,E),(26,E),(27,E),(28,E),
                  (31,E),(32,E),(33,E),(34,E),(35,E),(36,E),(37,E),(38,E),
                  (41,E),(42,E),(43,E),(44,B),(45,N),(46,E),(47,E),(48,E),
                  (51,E),(52,E),(53,E),(54,N),(55,B),(56,E),(57,E),(58,E),
                  (61,E),(62,E),(63,E),(64,E),(65,E),(66,E),(67,E),(68,E),
                  (71,E),(72,E),(73,E),(74,E),(75,E),(76,E),(77,E),(78,E),
                  (81,E),(82,E),(83,E),(84,E),(85,E),(86,E),(87,E),(88,E)]


-- Crear el tablero inicial con las fichas en el centro
--tableroInicial :: [(Int, TipoCuadrado)]
--tableroInicial = 
--  let base = [(cuadro, E) | cuadro <- tablero]
--  in sust 44 B $ sust 55 B $ sust 45 N $ sust 54 N base

-- Traducir un número del tablero a coordenadas (i, j)
deNumACoor n
  | n `elem` tablero = let (row, col) = (n `div` 10, n `mod` 10) in (row, col)
  | otherwise         = error "Número fuera del tablero"


-- Sustituir un valor en el tablero
sust :: Int -> TipoCuadrado -> [(Int, TipoCuadrado)] -> [(Int, TipoCuadrado)]
sust _ _ [] = []
sust coord tipo (x:xs)
  | fst x == coord = (coord, tipo) : xs
  | otherwise      = x : sust coord tipo xs


-- Mostrar tablero
mostrarTablero :: [(Int, TipoCuadrado)] -> String
mostrarTablero tablero =
  intercalate "\n" $ map (concatMap mostrarCuadro) (prepar8 (ordenarTablero tablero))
  where
    -- Convertir un TipoCuadrado a representación textual
    mostrarCuadro E = " . "
    mostrarCuadro B = " B "
    mostrarCuadro N = " N "

-- Ordenar el tablero según las coordenadas
ordenarTablero :: [(Int, TipoCuadrado)] -> [(Int, TipoCuadrado)]
ordenarTablero = sortBy (\(pos1, _) (pos2, _) -> compare pos1 pos2)

-- Dividir lista en chunks de 8
prepar8 :: [(Int, TipoCuadrado)] -> [[TipoCuadrado]]
prepar8 ls = tomar8 (map snd ls)

tomar8 :: [a] -> [[a]]
tomar8 [] = []
tomar8 xs = take 8 xs : tomar8 (drop 8 xs)

--Establecemos la fórmula de como llegar a las coordenadas de los vecinos
direccionesVecinos  = [-1,1,-10,10,-9,9, -11,11]

-- Encontrar los vecinos de una ficha dada su posición en el tablero
getVecinos :: Int -> [(Int, TipoCuadrado)] -> [(Int, TipoCuadrado)]
getVecinos pos tablero =
  let posibles = [pos + dir | dir <- direccionesVecinos]
      ficha = getValorCasilla pos tablero -- Valor del TipoCuadrado en la posición actual
      opuesto = getOpuesto ficha -- Opuesto de la ficha actual
  in [z | z <- tablero, elem (fst z) posibles, snd z /= E, snd z == opuesto]

--Obtener el contrario de la ficha, para saber cual encerrar (Opuesto del TipoCuadrado)
getOpuesto :: TipoCuadrado -> TipoCuadrado
getOpuesto B = N
getOpuesto N = B

--Obtener valor del TipoCuadrado de una casilla
getValorCasilla :: Int -> [(Int, TipoCuadrado)] -> TipoCuadrado
getValorCasilla pos ((p, tipo):xs)
  | pos == p  = tipo
  | otherwise = getValorCasilla pos xs


-- Verificar si una coordenada está dentro del tablero
coordenadasDentroDelTablero :: Int -> Bool
coordenadasDentroDelTablero pos = pos >= 11 && pos <= 88 && (pos `mod` 10) /= 0 && (pos `mod` 10) /= 9


-- Calcular las posibles tiradas para un jugador
posiblesTiradas :: TipoCuadrado -> [(Int, TipoCuadrado)] -> [Int]
posiblesTiradas tipo tablero =
  let opuesto = getOpuesto tipo
      posibles = [pos | (pos, ficha) <- tablero, ficha == E, puedeEncerrar pos tipo tablero]
  in 
    --trace ("Posibles tiradas para " ++ show tipo ++ ": " ++ show posibles) 
  posibles


-- Verificar si una casilla puede encerrar fichas contrarias
puedeEncerrar :: Int -> TipoCuadrado -> [(Int, TipoCuadrado)] -> Bool
puedeEncerrar pos tipo tablero = 
  any (not . null) [obtenerTrayectoria pos dir tablero tipo | dir <- direccionesVecinos]
  where
    -- Obtener trayectoria de fichas a voltear en una dirección
    obtenerTrayectoria :: Int -> Int -> [(Int, TipoCuadrado)] -> TipoCuadrado -> [Int]
    obtenerTrayectoria inicio dir tablero tipo =
      let recorrido = takeWhile coordenadasDentroDelTablero [inicio + n * dir | n <- [1..]]
          fichas = map (`getValorCasilla` tablero) recorrido
          (opuestas, resto) = span (== getOpuesto tipo) fichas
      in if not (null resto) && head resto == tipo
         then take (length opuestas) recorrido
         else []

-- Obtener trayectoria de fichas a voltear en una dirección
obtenerTrayectoria :: Int -> Int -> [(Int, TipoCuadrado)] -> TipoCuadrado -> [Int]
obtenerTrayectoria inicio dir tablero tipo =
  let recorrido = takeWhile coordenadasDentroDelTablero [inicio + n * dir | n <- [1..]]
      fichas = map (`getValorCasilla` tablero) recorrido
      posiciones = zip recorrido fichas
      (opuestas, resto) = span (\(_, ficha) -> ficha == getOpuesto tipo) posiciones
  in trace ("Inicio: " ++ show inicio ++ ", Dirección: " ++ show dir ++ ", Recorrido: " ++ show recorrido ++ ", Fichas: " ++ show fichas ++ ", Opuestas: " ++ show opuestas) $
     if not (null resto) && snd (head resto) == tipo
     then map fst opuestas
     else []

-- Ejecutar tirada, se recibe como parámetro el número de casilla seleccionada, el tablero y el tipo cuadrado, se voltean las fichas encerradas
-- Ejecutar tirada, se recibe como parámetro el número de casilla seleccionada, el tablero y el tipo cuadrado, se voltean las fichas encerradas
ejecutarTirada :: Int -> [(Int, TipoCuadrado)] -> TipoCuadrado -> [(Int, TipoCuadrado)]
ejecutarTirada pos tablero tipo
  | not (coordenadasDentroDelTablero pos) = error "La posición está fuera del tablero"
  | getValorCasilla pos tablero /= E      = error "La casilla no está vacía"
  | otherwise = 
      let trayectorias = fichasAVoltear pos tablero tipo
          nuevoTablero = foldl voltear (sust pos tipo tablero) trayectorias
      in nuevoTablero
  where
    -- Encontrar las fichas que deben ser volteadas
    fichasAVoltear :: Int -> [(Int, TipoCuadrado)] -> TipoCuadrado -> [[Int]]
    fichasAVoltear pos tablero tipo =
      [trayectoria | dir <- direccionesVecinos, 
                     let trayectoria = obtenerTrayectoria pos dir tablero tipo, 
                     not (null trayectoria)]

    -- Obtener trayectoria de fichas a voltear en una dirección
    obtenerTrayectoria :: Int -> Int -> [(Int, TipoCuadrado)] -> TipoCuadrado -> [Int]
    obtenerTrayectoria inicio dir tablero tipo =
      let recorrido = takeWhile coordenadasDentroDelTablero [inicio + n * dir | n <- [1..]]
          fichas = map (`getValorCasilla` tablero) recorrido
          (opuestas, resto) = span (== getOpuesto tipo) fichas
      in if not (null resto) && head resto == tipo
         then take (length opuestas) recorrido
         else []

    -- Voltear las fichas en el tablero
    voltear :: [(Int, TipoCuadrado)] -> [Int] -> [(Int, TipoCuadrado)]
    voltear tablero trayectoria = foldl (\t pos -> sust pos tipo t) tablero trayectoria

-- Main para probar el juego
--main :: IO ()
--main = do
--  let tableroInicializado = tableroInicial
--  putStrLn "Tablero inicial:"
--  putStrLn (mostrarTablero tableroInicializado)
--  putStrLn "\nEjecutando jugada en posición 43 para Blanco (B):"
--  let tableroActualizado = ejecutarTirada 46 tableroInicializado B
--  putStrLn "\nTablero actualizado:"
--  putStrLn (mostrarTablero tableroActualizado)

-- Función principal del juego
main :: IO ()
main = do
  juego tableroInicial B -- Empieza el juego con la ficha Blanca (B)

-- Función que maneja el juego en sí, alternando entre jugadores
juego :: [(Int, TipoCuadrado)] -> TipoCuadrado -> IO ()
juego tablero tipo = do
    putStrLn "Tablero actual:"
    putStrLn (mostrarTablero tablero)  -- Usamos tu función para mostrar el tablero

    let posibles = posiblesTiradas tipo tablero -- Obtener las posibles jugadas

    -- Si no hay jugadas posibles, termina el turno y pasa al otro jugador
    if null posibles
        then do
            putStrLn "No hay jugadas posibles para este jugador. Pasa el turno."
            let siguienteJugador = getOpuesto tipo
            juego tablero siguienteJugador
        else do
            putStrLn "Posibles posiciones para realizar la jugada: "
            mapM_ print posibles -- Mostrar todas las posiciones posibles

            putStrLn "Selecciona una posición para hacer tu jugada (número de casilla): "
            hFlush stdout  -- Para asegurar que el mensaje se imprima antes de esperar entrada
            input <- getLine
            let posSeleccionada = read input :: Int

            -- Si la jugada es válida, ejecutamos la tirada
            if posSeleccionada `elem` posibles
                then do
                    let nuevoTablero = ejecutarTirada posSeleccionada tablero tipo
                    --putStrLn "Tablero después de la jugada:"
                    --putStrLn (mostrarTablero nuevoTablero)  -- Mostramos el tablero actualizado
                    let siguienteJugador = getOpuesto tipo
                    juego nuevoTablero siguienteJugador
                else do
                    putStrLn "Posición no válida, intenta nuevamente."
                    juego tablero tipo