f x = x + 1
g x = x * 2
h x = x - 3

-- Comprobación de la propiedad
propA1 = ((f . g) . h) 5
propA2 = (f . (g . h)) 5

-- Debería cumplirse que propA1 == propA2
