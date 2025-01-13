module Interaccion where

import Data.Char
import Data.List
import Text.Read (readMaybe)

data TipoCuadrado = E | X | O deriving (Eq, Show)
data Jugador = JugadorX | JugadorO deriving (Eq, Show)

tablero :: [(Int, Int)]
tablero = [(i, j) | i <- [1..3], j <- [1..3]]

tableroInicial :: [((Int, Int), TipoCuadrado)]
tableroInicial = [(cuadro, E) | cuadro <- tablero]

jugadasPosibles :: Jugador -> [((Int, Int), TipoCuadrado)] -> [(Int, Int)]
jugadasPosibles _ tab = [fst z | z <- tab, snd z == E]

sust :: Eq a => a -> b -> [(a, b)] -> [(a, b)]
sust _ _ [] = []
sust a b (x:xs)
  | fst x == a = (a, b) : xs
  | otherwise  = x : sust a b xs

actualizar :: Jugador -> (Int, Int) -> [((Int, Int), TipoCuadrado)] -> [((Int, Int), TipoCuadrado)]
actualizar jugador coor tab =
  if coor `elem` [fst z | z <- tab, snd z == E]
    then case jugador of
           JugadorX -> sust coor X tab
           JugadorO -> sust coor O tab
    else error "Error: coordenadas no válidas"

otroJugador :: Jugador -> Jugador
otroJugador JugadorX = JugadorO
otroJugador JugadorO = JugadorX

deNumACoor :: Int -> (Int, Int)
deNumACoor 1 = (1, 1)
deNumACoor 2 = (1, 2)
deNumACoor 3 = (1, 3)
deNumACoor 4 = (2, 1)
deNumACoor 5 = (2, 2)
deNumACoor 6 = (2, 3)
deNumACoor 7 = (3, 1)
deNumACoor 8 = (3, 2)
deNumACoor 9 = (3, 3)

tomar3 :: [a] -> [[a]]
tomar3 [] = []
tomar3 xs = take 3 xs : tomar3 (drop 3 xs)

prepar3 :: [((Int, Int), TipoCuadrado)] -> [[TipoCuadrado]]
prepar3 ls = tomar3 (map snd ls)

mostrarTablero :: [((Int, Int), TipoCuadrado)] -> String
mostrarTablero tablero =
  intercalate "\n-------\n" $ map (concatMap mostrarCuadro) (prepar3 tablero)
  where
    mostrarCuadro E = "   "
    mostrarCuadro X = " X "
    mostrarCuadro O = " O "

comprobarGanador :: [((Int, Int), TipoCuadrado)] -> Maybe Jugador
comprobarGanador tablero =
  let filas = map (map snd) (prepar3 tablero)
      cols = transpose filas
      diag1 = [snd (tablero !! i) | i <- [0, 4, 8]]
      diag2 = [snd (tablero !! i) | i <- [2, 4, 6]]
      lineas = filas ++ cols ++ [diag1, diag2]
  in case filter (all (== X)) lineas of
       (_:_) -> Just JugadorX
       [] -> case filter (all (== O)) lineas of
               (_:_) -> Just JugadorO
               [] -> Nothing

interaccion :: Jugador -> [((Int, Int), TipoCuadrado)] -> IO ()
interaccion jugador tablero = do
  putStrLn $ "Turno de " ++ show jugador
  putStrLn $ mostrarTablero tablero
  putStrLn "Elige una posición (1-9):"
  s1 <- getLine
  let s = readMaybe s1 :: Maybe Int
  case s of
    Just pos | pos >= 1 && pos <= 9 -> do
      let coor = deNumACoor pos
      if coor `elem` jugadasPosibles jugador tablero
        then do
          let tablero1 = actualizar jugador coor tablero
          case comprobarGanador tablero1 of
            Just ganador -> putStrLn $ "\n¡Ganador: " ++ show ganador ++ "!\n" ++ mostrarTablero tablero1
            Nothing ->
              if null (jugadasPosibles jugador tablero1)
                then putStrLn $ "\nEmpate. ¡Fin del juego!\n" ++ mostrarTablero tablero1
                else interaccion (otroJugador jugador) tablero1
        else putStrLn "Esa posición ya está ocupada." >> interaccion jugador tablero
    _ -> putStrLn "Entrada inválida. Intenta de nuevo." >> interaccion jugador tablero

main :: IO ()
main = interaccion JugadorX tableroInicial
