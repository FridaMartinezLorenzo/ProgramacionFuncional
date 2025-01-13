import Data.List

data Piezas = X | O | V deriving Show

type  Tablero  = [Piezas]
--- tablero podría ser take 9 (repeat V)

inicio = take 9 (repeat V)

dividir3 [] = []
dividir3 (a:bs) = (take 3 (a:bs)):dividir3 (drop 3 (a:bs))

inicioR = take 64 (repeat V)

dividir8 [] = []
dividir8 (a:bs) = (take 8 (a:bs)):dividir8 (drop 8 (a:bs))

mostrar = map show (dividir8 inicioR)
mostrarTablero = mapM_ putStrLn $ map show (dividir8 inicioR)

-- tiradasPosibles jugador coor tablero = 