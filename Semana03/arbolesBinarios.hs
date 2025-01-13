data Bin = B Bin Bin | Hoja Int deriving Show 

data BinO = BO Int BinO BinO | H Int deriving Show

data BinUni = Bi Int BinUni BinUni | Bi1 Int BinUni | Ho Int
     deriving Show

-- data Lista = L Lista Lista | C Int | Nil deriving Show
-- len(ls+ms) = len ls + len ms

data List  = M Int List | Null deriving Show

data AG = Ag Int [AG] | Nulo  

ponerComoLista Null = []
ponerComoLista (M n ls) = (n:) (ponerComoLista ls)

loContrario [] = Null
loContrario (a:bs) = M a (loContrario bs)

-- (n:) es la funcion cons (de Lisp, consing)

sumarList Null = 0
sumarList (M n ls) = n + sumarList ls 

transformar1 (Bi n izq der) = Bi 1 (transformar1 izq) (transformar1 der)
transformar1 (Bi1 n des) = Bi1 1 (transformar1 des)
transformar1 (Ho n) = (Ho 1) 


transformar0 (Bi n izq der) = Bi 0 (transformar0 izq) (transformar0 der)
transformar0 (Bi1 n des) = Bi1 0 (transformar0 des)
transformar0 (Ho n) = (Ho 0) 

transformar n (Bi x izq der) = Bi n (transformar n izq) (transformar n der)
transformar n (Bi1 x des) = Bi1 n (transformar n des)
transformar n (Ho x) = (Ho n) 

eje0 = Bi 3 (Bi 2 (Ho 3) (Ho 4)) (Bi1 3 (Bi 5 (Ho 7) (Ho 9)))
eje00 = Bi 5 eje0 eje0

eje1 = B (B (Hoja 1) (Hoja 2)) (B (Hoja 4) (Hoja 1))

eje2 = BO 3 ( BO 4 (H 1) (H 2)) (BO 5 (H 3) (H 10))

eje3 = BO 5 eje2 eje2

eje4 = B eje1 eje1

contarNodosB (Hoja n) = 1
contarNodosB (B izq der) = 1 + contarNodosB izq + contarNodosB der

alturaB (Hoja n) = 0
alturaB (B izq der) = 1+max (alturaB izq) (alturaB der)
-- Faltan soluciones para àrboles BO...

--- Un àrbol infinito!!!
arbolInfinito = BO 3 arbolInfinito arbolInfinito

sumaBO (H n) = n
sumaBO (BO n izq der) = n + sumaBO izq + sumaBO der

