module Othello where
import System.IO (hFlush, stdout)
import Data.List (intercalate)
import Debug.Trace (trace)


import Data.Char
import Data.List
import Text.Read (readMaybe)
import Text.XHtml (table)

data TipoCuadrado = E | B | N deriving (Eq, Show) -- Empty, Blanco, Negro
data Jugador = JugadorBlanco | JugadorNegro deriving (Eq, Show)

-- Crear tablero 8x8
tablero :: [Int]
tablero = [10 * i + j | i <- [1..8], j <- [1..8]]

-- Tablero inicial
tableroInicial :: [(Int, TipoCuadrado)]
tableroInicial = [(11,E),(12,E),(13,E),(14,B),(15,N),(16,E),(17,E),(18,E),
                  (21,B),(22,E),(23,E),(24,E),(25,E),(26,E),(27,E),(28,E),
                  (31,E),(32,E),(33,E),(34,E),(35,E),(36,E),(37,E),(38,E),
                  (41,B),(42,E),(43,E),(44,B),(45,N),(46,E),(47,N),(48,E),
                  (51,E),(52,E),(53,E),(54,N),(55,B),(56,E),(57,E),(58,E),
                  (61,E),(62,E),(63,E),(64,E),(65,E),(66,E),(67,E),(68,E),
                  (71,E),(72,E),(73,E),(74,N),(75,E),(76,E),(77,E),(78,E),
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


-- Convertir TipoCuadrado a String
tipoCuadradoToString :: TipoCuadrado -> String
tipoCuadradoToString E = "E"
tipoCuadradoToString B = "B"
tipoCuadradoToString N = "N"


-- Mostrar tablero
mostrarTablero :: [(Int, TipoCuadrado)] -> String
mostrarTablero tablero =
  intercalate "\n" $ map (concatMap mostrarCuadro) (prepar8 (ordenarTablero tablero))
  where
    -- Convertir un TipoCuadrado a representación textual
    mostrarCuadro E = " . "
    mostrarCuadro B = " B "
    mostrarCuadro N = " N "

--getTablero retorna unicamente una matriz de 8x8 con los valores de las fichas, pero las fichas como String
getTablero :: [(Int, TipoCuadrado)] -> String
getTablero tablero = 
    intercalate "\n" $ map (concatMap mostrarCuadrado) (prepar8 (ordenarTablero tablero))
  where
    mostrarCuadrado :: TipoCuadrado -> String
    mostrarCuadrado E = " . "
    mostrarCuadrado B = " B "
    mostrarCuadrado N = " N "

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


-- Obtener el número de fichas blancas que hay en el tablero
getBlancas :: [(Int, TipoCuadrado)] -> Int
getBlancas tablero = length $ filter (\(_, tipo) -> tipo == B) tablero

-- Obtener el número de fichas negras que hay en el tablero
getNegras :: [(Int, TipoCuadrado)] -> Int
getNegras tablero = length $ filter (\(_, tipo) -> tipo == N) tablero
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

-- Función para ejecutar una tirada aleatoria, colocando la ficha en la posición deseada
-- sin verificar si es una jugada válida. Si la jugada es válida, voltea las fichas correspondientes.
ejecutarTiradaAleatoria :: Int -> [(Int, TipoCuadrado)] -> TipoCuadrado -> [(Int, TipoCuadrado)]
ejecutarTiradaAleatoria pos tablero tipo
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

-- Heuristica, en base a que te va a contestar la compu

--Dadas las opciones dadas elegir el elemento 
--Dale prioridad a llegar a las esquinas, en caso de pover tener el 11,18, 81 ó 88
--evita los 3 cuadros que rodean las esquinas del 11 sería el 12, 21 y 22 ; del 18 serian el 17,27,28 : del 81 sería el 71,72,82 y del 88 sería el 77,78,87 
--Intenta llegar y tomar tambien los bordes del tablero, en caso de poder tener el 13, 14, 15, 16, 23, 24, 25, 26, 31, 32, 36, 37, 43, 47, 53, 57, 63, 64, 65, 66, 73, 74, 75, 76, 83, 84, 85, 86
-- Heurística para evaluar las posibles jugadas
evaluarJugada :: Int -> Int
evaluarJugada pos
  -- Prioridad máxima: esquinas
  | pos `elem` [11, 18, 81, 88] = 100
  -- Evitar las posiciones junto a las esquinas
  | pos `elem` [12, 21, 22, 17, 27, 28, 71, 72, 82, 77, 78, 87] = -100
  -- Prioridad media: bordes
  | pos `elem` [13, 14, 15, 16, 23, 24, 25, 26, 31, 32, 36, 37, 43, 47,
                53, 57, 63, 64, 65, 66, 73, 74, 75, 76, 83, 84, 85, 86] = 50
  -- Otras posiciones tienen prioridad base
  | otherwise = 10

-- Elegir la mejor jugada basándose en la heurística
mejorJugada :: [Int] -> Int
mejorJugada posiblesTiradas =
  snd $ maximum [(evaluarJugada pos, pos) | pos <- posiblesTiradas]

-- Función para que la computadora elija la posición que ha de jugar
elegirJugadaComputadora :: [(Int, TipoCuadrado)] -> TipoCuadrado -> IO Int
elegirJugadaComputadora tablero tipo = do
  putStrLn "La computadora (Blanco) está calculando su jugada..."
  let posibles = posiblesTiradas tipo tablero  -- Obtener todas las posibles jugadas
      posiblesValidas = filter (\pos -> puedeEncerrar pos tipo tablero) posibles  -- Filtrar las jugadas válidas
  if null posiblesValidas
    then do
      putStrLn "La computadora no tiene jugadas válidas. Pasa el turno."
      return (-1)  -- Devolver -1 para indicar que no hay jugadas válidas
    else do
      let posSeleccionada = mejorJugada posiblesValidas  -- Elegir la mejor jugada válida
      putStrLn $ "La computadora (Blanco) elige la posición: " ++ show posSeleccionada
      return posSeleccionada  -- Devolver la posición seleccionada

--Funcion para que se realice la jugada de la computadora
---realizarJugadaComputadora :: [(Int, TipoCuadrado)] -> TipoCuadrado -> IO [(Int, TipoCuadrado)]
---realizarJugadaComputadora tablero tipo = do
---  putStrLn "La computadora (Blanco) está calculando su jugada..."
---  let posibles = posiblesTiradas tipo tablero
---      posiblesValidas = filter (\pos -> puedeEncerrar pos tipo tablero) posibles
---  if null posiblesValidas
---    then do
---      putStrLn "La computadora no tiene jugadas válidas. Pasa el turno."
---      return tablero  -- No hay cambios en el tablero
---    else do
---      let posSeleccionada = mejorJugada posiblesValidas  -- Elegir la mejor jugada válida
---      putStrLn $ "La computadora (Blanco) elige la posición: " ++ show posSeleccionada
---      return (ejecutarTirada posSeleccionada tablero tipo)  -- Ejecutar la jugada y devolver el nuevo tablero


-- Función principal del juego
--main :: IO ()
--main = do
--  juego tableroInicial N -- Empieza el juego con la ficha Negra (N)

-- Función que maneja el juego en sí, alternando entre jugadores
juego :: [(Int, TipoCuadrado)] -> TipoCuadrado -> IO ()
juego tablero tipo = do
    putStrLn "Tablero actual:"
    putStrLn (mostrarTablero tablero)  -- Usamos tu función para mostrar el tablero

    let posibles = posiblesTiradas tipo tablero -- Obtener las posibles jugadas

    -- Si no hay jugadas posibles, termina el turno y pasa al otro jugador
    if null posibles
        then do
            putStrLn $ "No hay jugadas posibles para el jugador " ++ show tipo ++ ". Pasa el turno."
            let siguienteJugador = getOpuesto tipo
            juego tablero siguienteJugador
        else do
            if tipo == N  -- Turno del usuario
                then do
                    putStrLn "Posibles posiciones para realizar la jugada: "
                    print posibles -- Mostrar todas las posiciones posibles

                    putStrLn "Selecciona una posición para hacer tu jugada (número de casilla): "
                    hFlush stdout  -- Asegurar que el mensaje se imprima antes de esperar entrada
                    input <- getLine
                    let posSeleccionada = read input :: Int

                    -- Si la jugada es válida, ejecutamos la tirada
                    if posSeleccionada `elem` posibles
                        then do
                            let nuevoTablero = ejecutarTirada posSeleccionada tablero tipo
                            let siguienteJugador = getOpuesto tipo
                            juego nuevoTablero siguienteJugador
                        else do
                            putStrLn "Posición no válida, intenta nuevamente."
                            juego tablero tipo
                else do  -- Turno de la computadora (Blanco)
                    putStrLn "La computadora (Blanco) está calculando su jugada..."
                    let posiblesValidas = filter (\pos -> puedeEncerrar pos tipo tablero) posibles
                    if null posiblesValidas
                        then do
                            putStrLn "La computadora no tiene jugadas válidas. Pasa el turno."
                            let siguienteJugador = getOpuesto tipo
                            juego tablero siguienteJugador
                        else do
                            let posSeleccionada = mejorJugada posiblesValidas -- Elegir la mejor jugada válida
                            putStrLn $ "La computadora (Blanco) elige la posición: " ++ show posSeleccionada
                            let nuevoTablero = ejecutarTirada posSeleccionada tablero tipo
                            let siguienteJugador = getOpuesto tipo
                            juego nuevoTablero siguienteJugador
