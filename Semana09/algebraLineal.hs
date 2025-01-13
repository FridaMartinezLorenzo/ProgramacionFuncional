
import Data.List

-- prodInterno [1,2,3] [4,5,6] = 1*4+2*5+3*6

prodInterno ls ms = sum $ zipWith (*) ls ms

-- mulEscalar 2 [[1,2],[3,4]] = [[2,4],[6,8]]

mulEscalar a lss = [(map (a*) ls) | ls <- lss]

-- transpuesta [[1,2],[3,4]] = [[1,3],[2,4]]

transpuesta lss = transpose lss

simetrica lss =  (transpuesta lss == lss)

sumaDeMatrices lss mss = [ zipWith (+) ls ms | (ls,ms) <- zip lss mss]

det1x1 [[a]] = a
det2x2 [[a,b],[c,d]] = a*d-b*c
det3x3 dato  = sum (zipWith (*) inter [((head dato)!!(i-1)* -- zipWith (*)
        det2x2 (map (delIndice i) (tail dato))) | i <- [1..length(dato)]])

det 1 [[a]] = a
det 2 [[a,b],[c,d]] = a*d-b*c
det 3 dato  = sum (zipWith (*) inter [((head dato)!!(i-1)* -- zipWith (*)
        (det 2 (map (delIndice i) (tail dato)))) | i <- [1..length(dato)]])
det n dato | n>3  = sum (zipWith (*) inter [((head dato)!!(i-1)* -- zipWith (*)
        (det (n-1) (map (delIndice i) (tail dato)))) | i <- [1..length(dato)]])

deter [[a]] = a
deter [[a,b],[c,d]] = a*d-b*c
deter dato = sum ls
      where
	ls = zipWith (*) inter ms
	ms = [((head dato)!!(i-1)* -- zipWith (*)
      	   (deter (map (delIndice i) (tail dato)))) | i <- [1..length(dato)]]


-- deter _ = error "No matriz cuadrada"
-- det 1 [[a]] = a
-- det 2 [[a,b],[c,d]] = a*d-b*c
-- det 3 dato  = [((head dato)!!(i-1),
--         inter (det 2) (map (delIndice i) (tail dato))) | i <- [1..length(dato)]] 
-- det n dato | n>3  = [((head dato)!!(i-1),
--         inter (det (n-1)) (map (delIndice i) (tail dato))) | i <- [1..length(dato)]] 

-- mulMatrices??? 

-- 3x4
-- [1,2,3,4]
-- [4,3,2,1]
-- [3,2,1,4]

-- 4x2
-- [1,2]
-- [3,4]
-- [3,5]
-- [2,4]
-- transpose: [1,3,3,2]
--            [2,4,5,4]

mulMat lss mss = [prodInterno ls ms | ls <-mss,ms <- transpose (mss)]

-- [ zip [a,b,c] (map (delIndex i)... | i <-[1..3]]
-- detNxN

inter = 1:(-1):inter

delIndice 1 (a:bs) = bs
delIndice n (a:bs) = a:(delIndice (n-1) bs)

-- (%i1) m: matrix([1,2,3,4],[4,2,3,1],[1,4,5,6],[4,3,2,1]);
--                                 [ 1  2  3  4 ]
--                                 [            ]
--                                 [ 4  2  3  1 ]
-- (%o1)                           [            ]
--                                 [ 1  4  5  6 ]
--                                 [            ]
--                                 [ 4  3  2  1 ]
-- (%i2) determinant(m);
-- (%o2)                                 30

-- (%i3) 
--  m: matrix([1,2,3,4,1],[4,2,3,1,2],[1,4,5,6,3],[4,3,2,1,4],[1,2,3,5,4]);
--                                [ 1  2  3  4  1 ]
--                                [               ]
--                                [ 4  2  3  1  2 ]
--                                [               ]
-- (%o3)                          [ 1  4  5  6  3 ]
--                                [               ]
--                                [ 4  3  2  1  4 ]
--                                [               ]
--                                [ 1  2  3  5  4 ]
-- (%i4) determinant(m);
-- (%o4)                                 100

-- (%i5) m: matrix([1,2,3,4,1],[4,2,3,1,2],[1,4,5,6,-3],[4,3,2,1,4],[1,2,3,5,4]);
--                               [ 1  2  3  4   1  ]
--                               [                 ]
--                               [ 4  2  3  1   2  ]
--                               [                 ]
-- (%o5)                         [ 1  4  5  6  - 3 ]
--                               [                 ]
--                               [ 4  3  2  1   4  ]
 --                               [                 ]
--                               [ 1  2  3  5   4  ]
-- (%i6) determinant(m);
-- (%o6)                                 10

-- Main> :l algebraLineal.hs
-- [1 of 1] Compiling Main             ( algebraLineal.hs, interpreted )
-- Ok, one module loaded.
-- *Main> det 3 [[1,2,3],[2,3,1],[4,5,6]]
-- -9
-- *Main> det 4 [[1,2,3,4],[4,2,3,1],[1,4,5,6]]
-- *** Exception: algebraLineal.hs:(26,1)-(31,79): Non-exhaustive patterns in function det

-- *Main> det 4 [[1,2,3,4],[4,2,3,1],[1,4,5,6],[4,3,2,1]]
-- 30
-- *Main> det 5 [[1,2,3,4,1],[4,2,3,1,2],[1,4,5,6,3],[4,3,2,1,4],[1,2,3,5,4]]
-- 100
-- *Main> det 5 [[1,2,3,4,1],[4,2,3,1,2],[1,4,5,6,-3],[4,3,2,1,4],[1,2,3,5,4]]
-- 10
-- *Main> :l algebraLineal.hs
-- [1 of 1] Compiling Main             ( algebraLineal.hs, interpreted )
-- Ok, one module loaded.
-- *Main> deter [[1,2,3,4,1],[4,2,3,1,2],[1,4,5,6,-3],[4,3,2,1,4],[1,2,3,5,4]]
-- 10
-- *Main> 
