import Data.Set
import System.Random

a = fromList [1,2,3,4,5,3,2,1]
b = fromList [1,5,6,7,8,8,7,6]
-- U = 
a |&&| b = intersection a b
a ~||~ b = union a b
a |\\| b = difference a b


