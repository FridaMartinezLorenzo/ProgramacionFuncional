--- module interaccion 

import Data.Char
import Control.Monad
import Data.List

-- import Data.Monad

data TipoCuadrado = E | X | O deriving (Eq,Show)
data Jugador = JugadorX | JugadorO deriving (Eq,Show)

tablero :: [(Integer, Integer)]
tablero = [(i,j) | i <- [1..8],j<-[1..8]]

tableroInicialT :: [((Integer, Integer), TipoCuadrado)]
tableroInicialT = [(cuadro,E)  |cuadro <- tablero]

tableroInicialX :: [((Integer, Integer), TipoCuadrado)]
tableroInicialX = sust ((5,5),E) ((5,5),X) (sust ((4,4),E) ((4,4),X) tableroInicialT)
	       
tableroInicial :: [((Integer, Integer), TipoCuadrado)]	       
tableroInicial = sust ((4,5),E) ((5,5),O) (sust ((5,4),E) ((4,4),O) tableroInicialX)
	       
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
		 (map show (map prepar8 $ tomar8 tablero))

sust a b [] = []
sust a b (c:ds) = if a==c then (b:ds) else c:(sust a b ds)

sustituir:: TipoCuadrado -> String -> [TipoCuadrado] -> [String]
sustituir x s [] = []
sustituir x s (a:bs) = if x==a then s:(sustituir x s bs) else
	  "wow": sustituir x s bs

actualizar JugadorX coor ls =
	   if elem coor [fst z | z <-ls] then
	      sust (coor,E) (coor,X) ls
	      else
		error "Error: coordenadas no válidas"

actualizar JugadorO coor ls =
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
-- deNumACoor 2 = (1,2)
-- deNumACoor 3 = (1,3)
-- deNumACoor 4 = (2,1)
-- deNumACoor 5 = (2,2)
-- deNumACoor 6 = (2,3)
-- deNumACoor 7 = (3,1)
-- deNumACoor 8 = (3,2)
-- deNumACoor 9 = (3,3)
-- deNumACoor :: Integer -> 
-- deNumACoor n = (zip tableroInicial [1..])!!(n+1)

-- deCoor2Num (1,1) = 1
-- deCoor2Num (1,2) = 2
-- deCoor2Num (1,3) = 3
-- deCoor2Num (2,1) = 4
-- deCoor2Num (2,2) = 5
-- deCoor2Num (2,3) = 6
-- deCoor2Num (3,1) = 7
-- deCoor2Num (3,2) = 8
-- deCoor2Num (3,3) = 9

--- ... faltan casos 

main = interaccion JugadorX tableroInicial

-- interaccion JugadorX tablero = do
--   	       			putStr "gana X"
-- interaccion JugadorO tablero = do
--   	       			putStr "gana O"

interaccion :: Show a1 => Jugador -> [(a2, a1)] -> IO b
interaccion jugador tablero = do
     putStrLn "Juega .."
     putStrLn (show jugador)
     putStrLn "en el tablero..."
     putStrLn (show (prepar8 tablero))     
     putStrLn "Dame un entero"
     s1 <- getLine
     let s = read s1 :: Integer
     let coor = deNumACoor s
     let jugador1 = otroJugador jugador  ---
--     putStrLn (show coor)
     let tablero1 = tablero --- actualizar jugador coor tablero
     putStrLn (show (prepar8 tablero1))
     interaccion jugador1 tablero1 

tomar8 [] = []
tomar8 (a:bs) = (take 8 (a:bs)):(tomar8 (drop 8 (a:bs)))

prepar8 ls = tomar8 (snd (unzip ls))

coor2num = zip (fst (unzip tableroInicial) ) [1..]
num2coor = map invertir coor2num
invertir (a,b) = (b,a)














--impresioTablero tablero =

--     coor 
--     putStr (show (
--     putStr (show (actualizar JugadorX coor tableroInicial))

-- *Main> actualizar JugadorX  (1,2) (actualizar JugadorO (2,3) (actualizar JugadorX (2,2) tableroInicial))
-- [((1,1),E),((1,2),X),((1,3),E),((2,1),E),((2,2),X),((2,3),O),((3,1),E),((3,2),E),((3,3),E)]
