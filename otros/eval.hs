eval -> Term  M Int
eval Con a   Return a
eval Div t u   case eval t of
Raise e  Raise e
Return a 
case eval u of
Raise e  Raise e
Return b 
if b  
then Raise divide by zero
else Return a  b