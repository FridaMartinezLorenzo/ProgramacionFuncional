
integrar d = sum [x**3*d | x<-[0.0,d..2.0]]

-- integrarF :: (Float -> Float) -> Float -> Float -> Float 
integrarF d a b = sum [sin(x)*d | x<-[a,d..b]]
integrarF2 d a b = sum [x**2*d | x<-[a,d..b]]
integrarF3 f d a b = sum [(f x)*d | x<-[a,d..b]]

--- Problema de examen:
--- Calcule a dos digitos de aproximación la integral de sen(x)
--- desde 0 a 1.5. (0.929263)

-- Ejercicios de matrices:
-- 1) Multiplicar un escalar por un vector (horizontal).
-- Ejemplo: mulEscalar 2 [1,2,3] - - > [2,4,6]
-- 2) Sumar matrices 2x2;
-- Ejemplo: sumar2x2 [[1,2],[3,4]] [[2,1],[3,4]] - -> [[3,3],[5,8]]
-- 3) Multiplicar un escalar por una matriz 3x3;
-- 4) Elevar al cuadrado una matriz 2x2;
-- 5) Producto vectorial de vectores 3
-- x3...

--Ejercicio 1:
multiEscalarVecor n ls = (map (\x->x*n) ls)

--Ejercicio 2:
sumMatrices2x2 ls = (map (map (\x->x)) ls)

