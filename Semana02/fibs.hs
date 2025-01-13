
fib 0 = 1
fib 1 = 1 --casos base, estas ecuaciones
fib n | n>1 = fib(n-1) + fib(n-2) --caso recursivo o no base.

-- fib(4) = fib(3) + fib(2) = (fib(2) + fib(1)) + (f(1)+f(0))
-- =fib(2) +3 = fib(1)+fib(0) +3= 5

fact 0 = 1
fact n | n>0 = n*fact(n-1)

-- *Main> fib 35
-- 14930352

fibsC = 'a':'b':(zipWith (++) fibsC (tail fibsC))
fibs = 1:1:(zipWith (+) fibs (tail fibs))