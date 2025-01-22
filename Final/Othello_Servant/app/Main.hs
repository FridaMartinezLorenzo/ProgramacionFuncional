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

-- Estado global del juego (tablero y turno)
tipoInicial :: TipoCuadrado
tipoInicial = N

tableroInicialEstado :: ([(Int, TipoCuadrado)], TipoCuadrado)
tableroInicialEstado = (tableroInicial, tipoInicial)

main :: IO ()
main = do
  estadoJuego <- newMVar tableroInicialEstado
  putStrLn "Servidor corriendo en http://localhost:8080"
  run 8080 (serve (Proxy :: Proxy API) (servidor estadoJuego))

-- Implementación de la API
servidor :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> Server API
servidor estadoJuego = obtenerEstado estadoJuego
               :<|> realizarJugada estadoJuego
               :<|> reiniciarTablero estadoJuego

-- Obtener el estado actual del juego
obtenerEstado :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> Handler TableroResponse
obtenerEstado estadoJuego = do
  (tablero, turno) <- liftIO $ readMVar estadoJuego
  return $ TableroResponse (mostrarTablero tablero) (show turno)

-- Realizar una jugada
realizarJugada :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> JugadaRequest -> Handler TableroResponse
realizarJugada estadoJuego (JugadaRequest pos jugadorStr) = do
  let tipo = if jugadorStr == "Negro" then N else B
  liftIO $ modifyMVar estadoJuego $ \(tablero, turno) ->
    if turno /= tipo
      then return ((tablero, turno), TableroResponse (mostrarTablero tablero) ("No es tu turno: " ++ show turno))
      else if pos `notElem` posiblesTiradas tipo tablero
        then return ((tablero, turno), TableroResponse (mostrarTablero tablero) "Movimiento inválido")
        else do
          let nuevoTablero = ejecutarTirada pos tablero tipo
          let nuevoTurno = getOpuesto turno
          return ((nuevoTablero, nuevoTurno), TableroResponse (mostrarTablero nuevoTablero) ("Turno de: " ++ show nuevoTurno))

-- Reiniciar el tablero
reiniciarTablero :: MVar ([(Int, TipoCuadrado)], TipoCuadrado) -> Handler TableroResponse
reiniciarTablero estadoJuego = do
  liftIO $ modifyMVar_ estadoJuego (\_ -> return tableroInicialEstado)
  return $ TableroResponse (mostrarTablero (fst tableroInicialEstado)) ("Turno de: " ++ show tipoInicial)

-- Ejemplo de uso
tableroComoMatriz :: [[TipoCuadrado]]
tableroComoMatriz = convertirTablero tableroInicial
