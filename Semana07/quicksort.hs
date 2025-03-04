import Data.List
import System.Random

ordRapido [] = []
-- a es el pivote actual
ordRapido (a:bs) =
	  ordRapido [ x | x <- bs,x <=a] ++ [a] ++ ordRapido [x | x<-bs,x>a]

--- Algoritmo de fusion

dividir ls = (take m ls, drop m ls)
	where
		n= length ls
		m = div n 2
		
fusionOrdHibrido [] = []
fusionOrdHibrido [a] = [a]
fusionOrdHibrido (a:bs) = let (l1,l2) = dividir (a:bs) in
	  fusionar (insOrd l1) (fusionOrdHibrido l2)


fusionOrd [] = []
fusionOrd [a] = [a]
fusionOrd (a:bs) = let (l1,l2) = dividir (a:bs) in
	  fusionar (fusionOrd l1) (fusionOrd l2)

fusionOrd3 [] = []
fusionOrd3 [a] = [a]
fusionOrd3 [a,b] = if a<=b then [a,b] else [b,a]
fusionOrd3 (a:bs) = let (l1,l2,l3) = dividir3 (a:bs) in
	  fusionar (fusionar (fusionOrd l1) (fusionOrd l2)) (fusionOrd l3)

dividir3 ls = (l1, l2, l3)
	where
		n= length ls
		m = div n 3
		l1=take  m ls
		l2=take  m (drop m ls)
		l3=take  (2*m) (drop (2*m) ls)
		


fusionar ls [] = ls
fusionar [] ls = ls
fusionar (a:bs) (c:cs) =
	 if a<=c then a:(fusionar bs (c:cs)) else c:(fusionar (a:bs) cs)

selOrd [] = []
selOrd (a:bs) = c:selOrd (delete c (a:bs))
	where
		c=minimum (a:bs)

insOrd [] = []
insOrd (a:bs) = colocar a (insOrd bs)

colocar a [] = [a]
colocar a (b:bs) = if a<=b then a:b:bs else b:(colocar a bs)

threeCoins :: StdGen -> (Bool, Bool, Bool)
threeCoins gen = 
    let (firstCoin, newGen) = random gen
        (secondCoin, newGen') = random newGen
        (thirdCoin, newGen'') = random newGen'
    in  (firstCoin, secondCoin, thirdCoin)
-- threeCoins (mkStdGen 21)