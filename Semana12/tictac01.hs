
import Data.Char
import Control.Monad
import Data.List

-- import Data.Monad

data TipoCuadrado = E | X | O deriving (Eq,Show)
data Jugador = JugadorX | JugadorO deriving (Eq,Show)

tablero = [(i,j) | i <- [1..3],j<-[1..3]]
tableroInicial = [(cuadro,E)  |cuadro <- tablero]

jugadasPosibles jugador tab = [fst z | z <- tab, snd z == E]
-- actualizar jugador tirada tab =
--- necesitamos una función de sustitución: sust a b ls
--- ejemplo sust 2 4 [1,2,3] --> [1,4,3]

-- actualizar JugadorX (2,2) [((1,1),E),((1,2),E),((1,3),E),((2,1),E),((2,2),E),((2,3),E),((3,1),E),((3,2),E),((3,3),E)]

-- da [((1,1),E),((1,2),E),((1,3),E),((2,1),E),((2,2),X),((2,3),E),((3,1),E),((3,2),E),((3,3),E)]

imprime tablero =
o	putStrLn $ intercalate "\n-------\n" (map show (map prepar3 $ tomar3 tablero))
sust a b [] = []
sust a b (c:ds) = if a==c then (b:ds) else c:(sust a b ds)

actualizar jugador coor ls | jugador==JugadorX =
	   if elem coor [fst z | z <-ls] then
	      sust (coor,E) (coor,X) ls
	      else
		error "Error: coordenadas no válidas"

actualizar jugador coor ls | jugador==JugadorO =
	   if elem coor [fst z | z <-ls] then
	      sust (coor,E) (coor,O) ls
	      else
		error "Error: coordenadas no válidas"

-- case of
--       a
--       b
--       c

-- Proyecto: Programar el juego de othello en versión completa
-- equipado con inteligencia artificial con el método minimax
-- y la poda alfa-beta.

otroJugador JugadorX = JugadorO
otroJugador JugadorO = JugadorX

cambiar 1 = 0
cambiar 0 = 1

interaccion t = do
     putStrLn "Juega X"
     putStrLn "Dame coordenadas"
     coor <- getLine
     let t1 = cambiar t  ---
--     coor 
--     putStr (show (
--     putStr (show (actualizar JugadorX coor tableroInicial))
     putStrLn coor
     interaction t1 

-- *Main> actualizar JugadorX  (1,2) (actualizar JugadorO (2,3) (actualizar JugadorX (2,2) tableroInicial))
-- [((1,1),E),((1,2),X),((1,3),E),((2,1),E),((2,2),X),((2,3),O),((3,1),E),((3,2),E),((3,3),E)]

tomar3 [] = []
tomar3 (a:bs) = (take 3 (a:bs)):(tomar3 (drop 3 (a:bs)))

prepar3 ls = snd (unzip ls)

--impresioTablero tablero = 