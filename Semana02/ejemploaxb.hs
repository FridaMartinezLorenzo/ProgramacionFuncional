

data ColorC = Blanco | Amarillo | Rojo deriving Show
data ColorF = Negro | Azul | Verde | Violeta deriving Show
data EstadoA = Triste | Enojado  | Cumbiambero | Indiferente |
     Alegre deriving Show

combinar :: (ColorC, ColorF) -> EstadoA
combinar (Amarillo, Verde) = Cumbiambero
combinar (Rojo, Azul) = Enojado
combinar (Blanco, Azul) = Triste
combinar (_,_) = Indiferente

combinar2 Rojo Azul = Indiferente

suma (a,b) = a+b

--- Vimos hoy atractores (pullbacs)
--- Producto cartesiano
--- Datos definidos por el usuario
--- El uso de Show (para mostrar datos definidos por el usuario)
--- Funciones seccionados
--- Y algo de funciones anònimas
--- Algo de Erlang...