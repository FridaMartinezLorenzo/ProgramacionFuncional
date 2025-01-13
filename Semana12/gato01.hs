--- module interaccion 

import Data.Char
import Control.Monad
import Data.List

-- import Data.Monad

data TipoCuadrado = E | X | O deriving (Eq,Show)
data Jugador = JugadorX | JugadorO deriving (Eq,Show)

tablero = [(i,j) | i <- [1..3],j<-[1..3]]
tableroInicial = [(cuadro,E)  |cuadro <- tablero]
--- 1 2 3
--- 4 5 6
--- 7 8 9

-- o | o|
-- ---------
--   | x|
-- --------
--   |  | x

jugadasPosibles jugador tab = [fst z | z <- tab, snd z == E]
-- actualizar jugador tirada tab =
--- necesitamos una función de sustitución: sust a b ls
--- ejemplo sust 2 4 [1,2,3] --> [1,4,3]

-- actualizar JugadorX (2,2) [((1,1),E),((1,2),E),((1,3),E),((2,1),E),((2,2),E),((2,3),E),((3,1),E),((3,2),E),((3,3),E)]

-- da [((1,1),E),((1,2),E),((1,3),E),((2,1),E),((2,2),X),((2,3),E),((3,1),E),((3,2),E),((3,3),E)]

imprime tablero =
	putStrLn $ intercalate "\n-------\n"
		 (map show (map prepar3 $ tomar3 tablero))

sust a b [] = []
sust a b (c:ds) = if a==c then (b:ds) else c:(sust a b ds)

actualizar jugadorX coor ls =
	   if elem coor [fst z | z <-ls] then
	      sust (coor,E) (coor,X) ls
	      else
		error "Error: coordenadas no válidas"

actualizar jugadorO coor ls =
	   if elem coor [fst z | z <-ls] then
	      sust (coor,E) (coor,O) ls
	      else
		error "Error: coordenadas no válidas"

-- case of -- existe case, switch 
--       a
--       b
--       c

-- Proyecto: Programar el juego de othello en versión completa
-- equipado con inteligencia artificial con el método minimax
-- y la poda alfa-beta.

otroJugador JugadorX = JugadorO
otroJugador JugadorO = JugadorX


deNumACoor 1 = (1,1)
deNumACoor 2 = (1,2)
deNumACoor 3 = (1,3)
deNumACoor 4 = (2,1)
deNumACoor 5 = (2,2)
deNumACoor 6 = (2,3)
deNumACoor 7 = (3,1)
deNumACoor 8 = (3,2)
deNumACoor 9 = (3,3)

deCoor2Num (1,1) = 1
deCoor2Num (1,2) = 2
deCoor2Num (1,3) = 3
deCoor2Num (2,1) = 4  --- ... faltan casos 

main = interaccion JugadorX tableroInicial

interaccion jugador tablero = do
     putStrLn "Juega .."
     putStrLn (show jugador)
     putStrLn "Dame un entero"
     s1 <- getLine
     let s = read s1 :: Integer
     let coor = deNumACoor s
     putStrLn (show coor) 
     let jugador1 = otroJugador jugador  ---
     putStr (show (prepar3 tablero))
     let tablero1 = actualizar jugador1 coor tablero
     interaccion jugador tablero1 

tomar3 [] = []
tomar3 (a:bs) = (take 3 (a:bs)):(tomar3 (drop 3 (a:bs)))
prepar3 ls = snd (unzip ls)


















--impresioTablero tablero =

--     coor 
--     putStr (show (
--     putStr (show (actualizar JugadorX coor tableroInicial))

-- *Main> actualizar JugadorX  (1,2) (actualizar JugadorO (2,3) (actualizar JugadorX (2,2) tableroInicial))
-- [((1,1),E),((1,2),X),((1,3),E),((2,1),E),((2,2),X),((2,3),O),((3,1),E),((3,2),E),((3,3),E)]
