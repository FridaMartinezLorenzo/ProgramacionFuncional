--- Sean A, B conjuntos.
--- f: A -> B, (signatura, o flecha)
--  a |-> f(a) (regla de correspondencia) (maps to)
--- C, otro conjunto

--- Funciones de alto orden (representativas):
-- map
-- filter
-- foldr
-- foldl
-- scanl, scanr
-- zipWith
-- Funciones anònimas o lambda...

Explicaciones bàsicas
-- map :   map f [a1,a2,a3,a4,a5] se evalúa a
     [f a1, f a2, f a3, f a4, f a5]
Ejemplo de propiedad map f (map g ls) = map (f . g) ls      
-- filter
filter  cumple  [a1,a2,a3,a4,a5] se evalúa a
Ejemplo si a1, cumple, es decir cumple a1 es verdadero
Ejemplo si a2, cumple, es decir cumple a2 es verdadero
Ejemplo si a3, no cumple, es decir cumple a3 es falso
Ejemplo si a4, no cumple, es decir cumple a4 es falso
Ejemplo si a5, cumple, es decir cumple a5 es verdadero

[a1, a2, a5]
     
-- foldr,...
op : A -> B -> C
op es un operador binario, por ejemplo +, *, ++, ..
f x y = x*2+y+x*y (f es binario)
foldr (op) e [a1,a2,a3,a4] se evalua a
(e: semilla...):

(a1 op (a2 op (a3 op (a4 op e))))

-- foldl,..
foldl (op) e [a1,a2,a3,a4] se evalua a
(e: semilla...):

(((e op a1) op a2) op a3) op a4

-- scanl, scanr: estas funciones de alto orden que acumulan
aplicaciones de foldl y foldr...
scanl (op) e [a1,a2,a3,a4]
[e, e op a1, (e op a1) op a2),
(e op a1) op a2) op a3,
(((e op a1) op a2) op a3) op a4]
-- iterate (aplica una f a un valor recursiva e infinitamente)

iterate f a se evalùa a
f ( f ( f (f (f (f (f (f (f ... (a))))))))))))))

-- zipWith op [a1,a2,a3] [b1,b2,b3]
(op es un operador binario):
[a1 op b1,a2 op b2,a3 op b3]

-- Funciones anònimas o lambda...
(\x -> E(x)), las cuales complementan a las funciones de alto
orden, frecuentemente.

