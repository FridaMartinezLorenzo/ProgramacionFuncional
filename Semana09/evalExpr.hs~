data Expr = C Int | Mul Expr Expr | Plus Expr Expr deriving Show

eje1 = Mul (C 2) (C 4) 
eje2 = Plus (Mul (C 3) (C 10)) (C 10)
eje3 = Plus eje1 eje2

eval (C n) = n
eval (Plus t1 t2) = h
     where 
           h1 = eval t1
           h2 = eval t2
           h = h1 + h2
eval (Mul t1 t2) = h
     where 
           h1 = eval t1
           h2 = eval t2
           h = h1 * h2


evalContar (C n) = (n,1)
evalContar (Plus t1 t2) = (h,c)
     where 
           (h1,c1) = evalContar t1
           (h2,c2) = evalContar t2
           h = h1 + h2
           c = c1+c2
evalContar (Mul t1 t2) = (h,c)
     where 
           (h1,c1) = evalContar t1
           (h2,c2) = evalContar t2
           h = h1 * h2
           c = c1 + c2

evalContarMul (C n) = (n,1,0)
evalContarMul (Plus t1 t2) = (h,c,m1+m2)
     where 
           (h1,c1,m1) = evalContarMul t1
           (h2,c2,m2) = evalContarMul t2
           h = h1 + h2
           c = c1 + c2
evalContarMul (Mul t1 t2) = (h,c,m)
     where 
           (h1,c1,m1) = evalContarMul t1
           (h2,c2,m2) = evalContarMul t2
           h = h1 * h2
           c = c1 + c2
   	   m  = m1 + m2 + 1

evalImpresion (C n) = (n, "evaluando " ++ (show n++"\n"))
evalImpresion (Plus t1 t2) = (h,"eval plus"++(show h))
     where 
           (h1,s1) = evalImpresion t1
           (h2,s2) = evalImpresion t2
           h = h1 + h2
	   st = (show s1) ++ (show s2)
evalImpresion (Mul t1 t2) = (h,"eval mul "++(show h))
     where 
           (h1,s1) = evalImpresion t1
           (h2,s2) = evalImpresion t2
           h = h1 * h2
   	   st = (show s1) ++ (show s2)
