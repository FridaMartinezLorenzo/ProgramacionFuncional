-- subconjuntos [] = [[]]
-- subconjuntos [1]=[[1],[]]
-- subconjuntos [1,2]= (map (2:) [[1],[]] ) ++ [[1],[]]
-- subconjuntos [1,2,3]=
--         (map (3:) (subconjuntos [1,2])) ++ (subconjuntos [1,2])
import Data.Set

data E = Suma E E | Producto E E | I Float  deriving Show  

evaluar (Suma a b) = c1+c2
              where
                c1 = evaluar a
                c2 = evaluar b
evaluar (Producto a b) = c1*c2
              where
                c1 = evaluar a
                c2 = evaluar b
evaluar (I n) = n               



subconjuntos [] = [[]]
subconjuntos (a:bs) = (Prelude.map (a:) (subconjuntos bs)) ++ (subconjuntos bs)

subconjuntos' [] = [[]]
subconjuntos' (a:bs) = (Prelude.map (a:) sb) ++ sb
          where --abstracciones o renombramientos posteriores...
               sb = subconjuntos' bs

a |+| b= a+b+1
a &*& b = a*b*2
a |>| b = a ++ b ++ b ++ a

-- infixr, infixl, ..
infix 6 |<>| 
(|<>|) :: [a] -> [a] -> [a]
a |<>| b = a ++ b ++ (reverse b)  ++ (reverse a)