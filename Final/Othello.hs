module Othello where

import Data.Char
import Data.List
import Text.Read (readMaybe)

data TipoCuadrado = E | B | N deriving (Eq, Show) -- Empty, Blanco, Negro
data Jugador = JugadorBlanco | JugadorNegro deriving (Eq, Show)

-- Crear tablero 8x8
tablero :: [Int]
tablero = [10 * i + j | i <- [1..8], j <- [1..8]]

-- Crear el tablero inicial con las fichas en el centro
tableroInicial :: [(Int, TipoCuadrado)]
tableroInicial = 
  let base = [(cuadro, E) | cuadro <- tablero]
  in sust 44 B $ sust 55 B $ sust 45 N $ sust 54 N base

-- Traducir un número del tablero a coordenadas (i, j)
deNumACoor :: Int -> (Int, Int)
deNumACoor n
  | n `elem` tablero = let (row, col) = (n `div` 10, n `mod` 10) in (row, col)


-- Sustituir un valor en el tablero
sust :: Int -> TipoCuadrado -> [(Int, TipoCuadrado)] -> [(Int, TipoCuadrado)]
sust _ _ [] = []
sust coord tipo (x:xs)
  | fst x == coord = (coord, tipo) : xs
  | otherwise      = x : sust coord tipo xs

-- Mostrar tablero
mostrarTablero :: [(Int, TipoCuadrado)] -> String
mostrarTablero tablero =
  intercalate "\n" $ map (concatMap mostrarCuadro) (prepar8 tablero)
  where
    -- Convertir número a coordenadas y TipoCuadrado a texto
    mostrarCuadro E = " . "
    mostrarCuadro B = " B "
    mostrarCuadro N = " N "

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


--Se realiza una funcion para verificar que la lista de vecinos dada, esta dentro del rango del 
coordenadasDentroDelTablero :: Int -> Bool
coordenadasDentroDelTablero n =
  let (row, col) = deNumACoor n
  in row >= 1 && row <= 8 && col >= 1 && col <= 8

