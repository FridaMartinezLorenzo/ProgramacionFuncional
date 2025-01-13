-- -- (a+b)**n (n desde cero)
-- --     1
-- --    1 1
-- --   1 2 1
-- --  1 3 3 1
-- -- 1 4 6 4 1

-- -- ...
-- -- 1 10 45 120 210 252 210 120 45 10 1
-- -- 1 3 3 1
-- --   1 3 3 1
-- ----------
-- -- 1 4 6 2 1
-- --- [a,b,c,d]
-- ---   [a,b,c,d]
-- --- zipWith (+) [a,b,c,d] [a,b,c,d]

-- ---  fila n
-- --   fila n
-- -----------

-- -- (a+b)**10  =
-- --  10         9       2  8        3  7        4  6        5  5        6  4
-- -- (%o1) b   + 10 a b  + 45 a  b  + 120 a  b  + 210 a  b  + 252 a  b  + 210 a  b
-- --                                                 7  3       8  2       9      10
-- --                                          + 120 a  b  + 45 a  b  + 10 a  b + a
-- -- (%i2) 

-- --  10         9       2  8        3  7        4  6        5  5        6  4
-- -- (%o1) b   + 10 a b  + 45 a  b  + 120 a  b  + 210 a  b  + 252 a  b  + 210 a  b
-- --                                                 7  3       8  2       9      10
-- --                                          + 120 a  b  + 45 a  b  + 10 a  b + a
-- -- (%i2)



-- trian 0 = [1]
-- trian n | n>0  = zipWith (+) (b++[0]) ([0]++b)
--       where
-- 	b = trian (n-1)


-- --- Políticas o semánticas operacionales o estrategias de evaluación...

-- a) Una política de evaluación para los lenguajes imperativas es la
-- rápida o interna o llamada-por-valor (call-by-value). En esta política
-- la evaluación de la función f(a1,a2) es tal que primero se evalúan
-- a a1 y a2 y después se evalúa a f; i.e., se evalúan primero los argumentos
-- y después la función misma.
-- > def f(x,y):
-- ...     return x
-- ... 
-- >>> f(8,16)
-- [1,2,3,4,5,6,1/0
--  Conclusión: Python evalúa todo lo que puede aunque no lo necesite.
-- b) Una política de evaluación para lenguajes puros como Haskell es
-- llamada evaluación por name (call-by-name), perezosa, exterior o rápida.
-- En este caso la evaluación se da por la parte externa (la función en sí)
-- y posteriormente, si es necesario, por los argumentos.
-- Ejemplo:
-- f (x,y) = x
-- f (1,"esto es muy extraño") se evalúa a 1
-- f f(12,1/0) se evalúa a 12 (a lenguajes como Haskell no les importan
-- las vidas ajenas).
-- Otro ejemplo:
-- take 4 [1,2,3,4,5,6,1/0] da [1,2,3,4] ya que no se llega a utilizar
-- "el valor" 1/0.

tomar 1 ls = [head ls]
tomar n ls | n>1 =  (head ls): (tomar (n-1) (tail ls))

-- >  tomar 3 [4,5,6,7] --> 4: tomar 2 [5,6,7] --> 4: 5: tomar 1 [6,7]
-- >  4:5:6:[7] == [4,5,6,7]

-- La idea de flojera o pereza en Haskell es no considerar más elementos
-- de los estrictamente necesario. Así que la evaluación perezosa posibilita
-- o permite el tratar elemento co-inductivos.

-- En el caso de cerradura de conjuntos se busca minimalidad.
-- <1,succ> me da el álgebra inductiva de los naturales...
-- << <1,succ> >> si esto está contenido contenido en A, A tiene que ser
-- algo "grande" 
fibs = 1:1:zipWith (+) fibs (tail fibs)

--- La evaluación perezosa permite calcular trozos de estructuras infinitas:
--- el truco es que no se calcula más de lo necesario. En Python no existen
--- tales estructuras infinitas. (functuools)
--- Problema: Generar el triángulo de Pascal de forma infinita...

--- trian ++ [1]
--- [1]++trian 
-------------------
-- --- [1] ---------- [1]
-- trian = [1]:zipWith (+) (trian++[1]) ([1]++trian)
-- [[1],
--  [1],
--   [1,1],
-- [1,1]
-- -----
-- 0 1 2 1
-- 1 2 1 0
--   1 3 3 1
-- 1 3 3 1
--   1 4 6 4 1
-- 1 4 6 4 1


-- 1 5 10 10 5 1 
mizip ls = zipWith (+) ([0]++ls) (ls++[0])

 let trian = [1]:let trian = [1]:mizip trian in take 5 trian
 