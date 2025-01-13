--original
ts :: Integer -> [Integer]
ts n = (2 * n) : ts (n + 1)

resultado :: [Integer]
resultado = take 10 (ts 30)

--ts where
resultado1 :: [Integer]
resultado1 = take 10 (ts 30)
  where
    ts n = (2 * n) : ts (n + 1)
