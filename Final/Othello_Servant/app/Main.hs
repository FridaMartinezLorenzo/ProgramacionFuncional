{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import Servant
import Network.Wai.Handler.Warp (run)
import GHC.Generics (Generic)
import Control.Concurrent.MVar
import Control.Monad.IO.Class (liftIO)
import Data.Aeson (ToJSON, FromJSON)
import Control.Exception (evaluate, try, SomeException)


-- Importar el código del juego
import Othello

-- Tipos para interactuar con la API
data JugadaRequest = JugadaRequest
  { posicion :: Int
  , jugador  :: String
  } deriving (Eq, Show, Generic)

data TableroResponse = TableroResponse
  { tableroActual :: String
  , turnoJugador  :: String
  } deriving (Eq, Show, Generic)

instance ToJSON TableroResponse
instance FromJSON JugadaRequest

-- API del juego
type API = 
       "estado" :> Get '[JSON] TableroResponse
  :<|> "jugada" :> ReqBody '[JSON] JugadaRequest :> Post '[JSON] TableroResponse
  :<|> "reiniciar" :> Post '[JSON] TableroResponse
  :<|> "posibles_tiradas" :> ReqBody '[JSON] String :> Post '[JSON] [Int]
  :<|> "jugada_computadora" :> Post '[JSON] TableroResponse  
  :<|> "blancas" :> Get '[JSON] Int  
  :<|> "negras" :> Get '[JSON] Int   
  :<|> "jugada_aleatoria" :> ReqBody '[JSON] JugadaRequest :> Post '[JSON] TableroResponse 


-- Estado global del juego (tablero y turno)
tipoInicial :: TipoCuadrado
tipoInicial = N

tableroInicialEstado :: ([(Int, TipoCuadrado)], TipoCuadrado)
tableroInicialEstado = (tableroInicial, tipoInicial)

--Genera posibles tiradas, dado un String de entrada que es el jugador, que convierta de string a TipoCuadrado y luego mande a llamar a posiblesTiradas
posiblesTiradasString :: String -> [(Int, TipoCuadrado)] -> [Int]
posiblesTiradasString jugador tablero =
  let tipoJugador = case jugador of
                      "N" -> N  -- Jugador Negro
                      "B" -> B  -- Jugador Blanco
                      _   -> E  -- En caso de que el string no sea válido, se considera vacío (puedes agregar un manejo de error aquí)
  in posiblesTiradas tipoJugador tablero



main :: IO ()
main = do
  estadoJuego <- newMVar tableroInicialEstado
  putStrLn "Servidor corriendo en http://localhost:8080"
  run 8080 (serve (Proxy :: Proxy API) (servidor estadoJuego))

-- Obtener el número de fichas blancas
obtenerBlancas :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> Handler Int
obtenerBlancas estadoJuego = do
  (tablero, _) <- liftIO $ readMVar estadoJuego
  return $ getBlancas tablero

-- Obtener el número de fichas negras
obtenerNegras :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> Handler Int
obtenerNegras estadoJuego = do
  (tablero, _) <- liftIO $ readMVar estadoJuego
  return $ getNegras tablero

-- Obtener el estado actual del juego
obtenerEstado :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> Handler TableroResponse
obtenerEstado estadoJuego = do
  (tablero, turno) <- liftIO $ readMVar estadoJuego
  return $ TableroResponse (getTablero tablero) (show turno)

-- Función para convertir un String a TipoCuadrado
stringToTipoCuadrado :: String -> TipoCuadrado
stringToTipoCuadrado "N" = N
stringToTipoCuadrado "B" = B
stringToTipoCuadrado _ = error "Tipo de jugador no válido. Debe ser 'N' o 'B'."

-- Función para ejecutar una tirada aleatoria a partir de un String
ejecutarTiradaAleatoriaString :: Int -> [(Int, TipoCuadrado)] -> String -> IO [(Int, TipoCuadrado)]
ejecutarTiradaAleatoriaString pos tablero jugadorStr = do
  let tipo = stringToTipoCuadrado jugadorStr  -- Convertir el String a TipoCuadrado
  return $ ejecutarTiradaAleatoria pos tablero tipo  -- Ejecutar la tirada aleatoria

-- Realizar una jugada aleatoria
realizarJugadaAleatoria :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> JugadaRequest -> Handler TableroResponse
realizarJugadaAleatoria estadoJuego (JugadaRequest pos jugadorStr) = do
  let tipo = stringToTipoCuadrado jugadorStr  -- Convertir el String a TipoCuadrado
  liftIO $ modifyMVar estadoJuego $ \(tablero, turno) ->
    if turno /= tipo
      then return ((tablero, turno), TableroResponse (getTablero tablero) ("No es tu turno: " ++ show turno))
      else do
        -- Ejecutar la jugada aleatoria usando evaluate para manejar excepciones
        resultado <- try (evaluate (ejecutarTiradaAleatoria pos tablero tipo)) :: IO (Either SomeException [(Int, TipoCuadrado)])
        case resultado of
          Left _ -> return ((tablero, turno), TableroResponse (getTablero tablero) "Error al ejecutar la jugada aleatoria")
          Right nuevoTablero -> do
            -- Cambiar el turno al jugador opuesto
            let nuevoTurno = getOpuesto turno
            -- Devolver el nuevo estado del tablero y el turno
            return ((nuevoTablero, nuevoTurno), TableroResponse (getTablero nuevoTablero) ("Turno de: " ++ show nuevoTurno))
            
-- Función para ejecutar una tirada a partir de un String
ejecutarTiradaString :: Int -> [(Int, TipoCuadrado)] -> String -> [(Int, TipoCuadrado)]
ejecutarTiradaString pos tablero jugadorStr =
  let tipo = stringToTipoCuadrado jugadorStr 
  in ejecutarTirada pos tablero tipo 

-- Realizar una jugada
realizarJugada :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> JugadaRequest -> Handler TableroResponse
realizarJugada estadoJuego (JugadaRequest pos jugadorStr) = do
  let tipo = stringToTipoCuadrado jugadorStr  -- Convertir el String a TipoCuadrado
  liftIO $ modifyMVar estadoJuego $ \(tablero, turno) ->
    if turno /= tipo
      then return ((tablero, turno), TableroResponse (getTablero tablero) ("No es tu turno: " ++ show turno))
      else if pos `notElem` posiblesTiradas tipo tablero
        then return ((tablero, turno), TableroResponse (getTablero tablero) "Movimiento inválido")
        else do
          -- Ejecutar la jugada usando evaluate para manejar excepciones
          resultado <- try (evaluate (ejecutarTiradaString pos tablero jugadorStr)) :: IO (Either SomeException [(Int, TipoCuadrado)])
          case resultado of
            Left _ -> return ((tablero, turno), TableroResponse (getTablero tablero) "Error al ejecutar la jugada")
            Right nuevoTablero -> do
              -- Cambiar el turno al jugador opuesto
              let nuevoTurno = getOpuesto turno
              -- Devolver el nuevo estado del tablero y el turno
              return ((nuevoTablero, nuevoTurno), TableroResponse (getTablero nuevoTablero) ("Turno de: " ++ show nuevoTurno))

realizarJugadaComputadora :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> Handler TableroResponse
realizarJugadaComputadora estadoJuego = do
  -- Obtener el estado actual del tablero y el turno
  (tablero, turno) <- liftIO $ readMVar estadoJuego

  -- Convertir el tipo de jugador a TipoCuadrado
  let tipo = stringToTipoCuadrado "B"  -- La computadora siempre juega con Blanco (B)

  -- Obtener la jugada de la computadora
  posSeleccionada <- liftIO $ elegirJugadaComputadora tablero tipo

  -- Si no hay jugadas válidas, pasar el turno
  if posSeleccionada == -1
    then do
      let nuevoTurno = getOpuesto tipo
      liftIO $ modifyMVar_ estadoJuego (\_ -> return (tablero, nuevoTurno))
      return $ TableroResponse (getTablero tablero) ("Turno de: " ++ show nuevoTurno)
    else do
      -- Realizar la jugada seleccionada por la computadora
      realizarJugada estadoJuego (JugadaRequest posSeleccionada "B")

-- Reiniciar el tablero
reiniciarTablero :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> Handler TableroResponse
reiniciarTablero estadoJuego = do
  liftIO $ modifyMVar_ estadoJuego (\_ -> return tableroInicialEstado)
  return $ TableroResponse (getTablero (fst tableroInicialEstado)) ("Turno de: " ++ show tipoInicial)


-- Implementación de la API
servidor :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> Server API
servidor estadoJuego = obtenerEstado estadoJuego
               :<|> realizarJugada estadoJuego
               :<|> reiniciarTablero estadoJuego
               :<|> posiblesTiradasHandler estadoJuego
               :<|> realizarJugadaComputadora estadoJuego 
               :<|> obtenerBlancas estadoJuego
               :<|> obtenerNegras estadoJuego  
               :<|> realizarJugadaAleatoria estadoJuego
  where
    -- Manejador para el endpoint "posibles_tiradas"
    posiblesTiradasHandler :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> String -> Handler [Int]
    posiblesTiradasHandler estadoJuego jugador = do
      (tablero, _) <- liftIO $ readMVar estadoJuego
      return $ posiblesTiradasString jugador tablero