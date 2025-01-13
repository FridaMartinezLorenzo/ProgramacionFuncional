-- Del artículo de Cheng y van Emden, first (p. 7) es take.
-- intsFrom(N) es [N..]
primes = sieve [2..]

sieve [] = []
sieve (a:bs) = a:(sieve (filtrado  bs a))

filtrado [] _ = []
filtrado (a:bs) p = if mod a p == 0  then filtrado bs p else (a:(filtrado bs p))
