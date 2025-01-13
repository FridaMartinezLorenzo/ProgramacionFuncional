> -- perms [] = []
> -- perms (a:bs)  = [(x:xs) | x <-(a:bs), xs <- delete x (x:xs)]]

> Ejercicio: Crear una funcion que tome un elemento a y una lista ls
>   y devuelva una nueva lista con el elemento colocado en todas las
>   posibles posiciones consecutivas de ls. Ejemplo:
>   colocar 5 [1,2,3]
>     genera 
>     [[5,1,2,3],[1,5,2,3],[1,2,5,3],[1,2,3,5]]

h = 10

