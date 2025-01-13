-- Definimos un tipo de datos para los días de la semana
data DiaSemana = Lunes | Martes | Miercoles | Jueves | Viernes | Sabado | Domingo
  deriving (Show, Eq)

-- Función que da el siguiente día de la semana
siguienteDia :: DiaSemana -> DiaSemana
siguienteDia Lunes     = Martes
siguienteDia Martes    = Miercoles
siguienteDia Miercoles = Jueves
siguienteDia Jueves    = Viernes
siguienteDia Viernes   = Sabado
siguienteDia Sabado    = Domingo
siguienteDia Domingo   = Lunes
