import pygame
import requests
import random

# URL base del servidor Haskell
BASE_URL = "http://localhost:8080"

# Colores
NEGRO = (0, 0, 0)
BLANCO = (255, 255, 255)
VACIO = (128, 128, 128)
VERDE = (0, 128, 0)

# Dimensiones del tablero
TAM_TABLERO = 8
TAM_CASILLA = 50  # Tamaño de cada casilla en píxeles
INICIO_X = 100
INICIO_Y = 100

# Inicialización de Pygame
pygame.init()
ANCHO = INICIO_X * 2.5 + TAM_TABLERO * TAM_CASILLA
ALTO = INICIO_Y * 3 + TAM_TABLERO * TAM_CASILLA
screen = pygame.display.set_mode((ANCHO, ALTO))
pygame.display.set_caption("Juego con Pygame y Servidor")

import random

def generar_numeros_aleatorios():
    # Crear el arreglo excluyendo los números dados
    arreglo = [
        num for rango in [(11, 18), (21, 28), (31, 38), (41, 48), (51, 58), (61, 68), (71, 78), (81, 88)]
        for num in range(rango[0], rango[1] + 1)
        if num not in {14, 15, 21, 41, 74, 47, 44, 45, 54, 55}
    ]
    
    return random.sample(arreglo, 1)


def obtener_blancas():
    try:
        response = requests.get(f"{BASE_URL}/blancas")
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error al obtener fichas blancas: {e}")
        return 0

def obtener_negras():
    try:
        response = requests.get(f"{BASE_URL}/negras")
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error al obtener fichas negras: {e}")
        return 0

def obtener_estado():
    """Obtiene el estado actual del tablero y el turno."""
    try:
        response = requests.get(f"{BASE_URL}/estado")
        response.raise_for_status()  # Lanza una excepción si la respuesta no es 200
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error al obtener el estado del tablero: {e}")
        return None

def realizar_jugada(posicion, jugador):
    """Realiza una jugada en el servidor."""
    try:
        data = {"posicion": posicion, "jugador": jugador}
        response = requests.post(f"{BASE_URL}/jugada", json=data)
        response.raise_for_status()  # Lanza una excepción si la respuesta no es 200
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error al realizar la jugada: {e}")
        return None

def realizar_jugada_aleatoria(posicion, jugador):
    """Realiza una jugada en el servidor, para la lista de numeros aleatorios"""
    try:
        data = {"posicion": posicion, "jugador": jugador}
        response = requests.post(f"{BASE_URL}/jugada_aleatoria", json=data)
        response.raise_for_status()  # Lanza una excepción si la respuesta no es 200
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error al realizar la jugada: {e}")
        return None

def reiniciar_tablero():
    """Reinicia el tablero en el servidor."""
    try:
        # Enviar la solicitud para reiniciar el tablero con las posiciones iniciales
        #response = requests.post(f"{BASE_URL}/reiniciar", json=posiciones_iniciales)
        response = requests.post(f"{BASE_URL}/reiniciar")
        response.raise_for_status()  # Lanza una excepción si la respuesta no es 200
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error al reiniciar el tablero: {e}")
        return None

def mostrar_tablero(tablero_str):
    """Muestra el tablero en formato legible."""
    filas = tablero_str.split("\n")
    for fila in filas:
        print(fila)

def obtener_posibles_tiradas(jugador):
    """Obtiene las posibles tiradas para un jugador desde el servidor."""
    try:
        response = requests.post(f"{BASE_URL}/posibles_tiradas", json=jugador)
        response.raise_for_status()  # Lanza una excepción si la respuesta no es 200
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error al obtener las posibles tiradas: {e}")
    return []

def realizar_jugada_computadora():
    """Realiza la jugada de la computadora en el servidor."""
    try:
        response = requests.post(f"{BASE_URL}/jugada_computadora")
        response.raise_for_status()  # Lanza una excepción si la respuesta no es 200
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error al realizar la jugada de la computadora: {e}")
        return None


def dibujar_casilla(screen, x, y):
    """Dibuja una casilla verde con contorno."""
    pygame.draw.rect(screen, VERDE, (x, y, TAM_CASILLA, TAM_CASILLA))
    pygame.draw.rect(screen, NEGRO, (x, y, TAM_CASILLA, TAM_CASILLA), 1)

def dibujar_pieza(screen, x, y, color):
    """Dibuja una pieza circular en el tablero."""
    pygame.draw.circle(screen, color, (x + TAM_CASILLA // 2, y + TAM_CASILLA // 2), TAM_CASILLA // 2 - 5)

def procesar_tablero(tablero_str):
    """
    Convierte el tablero en formato string a una lista de listas.
    Ejemplo de entrada: " .  .  .  .  .  .  .  . \n .  .  .  .  .  .  .  . \n ..."
    """
    filas = tablero_str.strip().split("\n")  # Dividir por saltos de línea y eliminar espacios al inicio/final
    tablero = []
    for fila in filas:
        # Eliminar espacios y convertir en lista de caracteres
        celdas = [celda.strip() for celda in fila.split()]
        tablero.append(celdas)
    return tablero

def dibujar_tablero(screen, tablero):
    """Dibuja el tablero con todas las casillas y piezas."""
    for i in range(TAM_TABLERO):
        for j in range(TAM_TABLERO):
            x = INICIO_X + j * TAM_CASILLA
            y = INICIO_Y + i * TAM_CASILLA
            dibujar_casilla(screen, x, y)  # Dibujar casilla verde con grid

            # Obtener el valor de la posición (i, j) en el tablero
            if i < len(tablero) and j < len(tablero[i]):
                if tablero[i][j] == "N":
                    dibujar_pieza(screen, x, y, NEGRO)
                elif tablero[i][j] == "B":
                    dibujar_pieza(screen, x, y, BLANCO)
                # Las celdas vacías (".") no se dibujan
                
def mostrar_posibles_tiradas(screen, tiradas):
    """Muestra las posibles tiradas del jugador en la pantalla."""
    font = pygame.font.Font(None, 25)
    texto = f"Tiradas posibles: {', '.join(map(str, tiradas))}"
    texto_render = font.render(texto, True, BLANCO)
    screen.blit(texto_render, (INICIO_X, INICIO_Y - 50))

def mostrar_mensaje(screen, mensaje, y_offset=0, color=BLANCO):
    """Muestra un mensaje en la pantalla."""
    font = pygame.font.Font(None, 30)
    texto_render = font.render(mensaje, True, color)
    screen.blit(texto_render, (INICIO_X, INICIO_Y + TAM_TABLERO * TAM_CASILLA + 20 + y_offset))

def realizar_jugadas_automáticas():
    """Realiza jugadas automáticas utilizando las posiciones aleatorias generadas."""
    posiciones_iniciales = generar_numeros_aleatorios()
    print("Posiciones iniciales generadas:", posiciones_iniciales)
    
    for posicion in posiciones_iniciales:
        estado = realizar_jugada_aleatoria(posicion, "N")
        if estado:
            print(f"Jugada realizada en la posición {posicion}")
        else:
            print(f"Error al realizar la jugada en la posición {posicion}")


def main():
    clock = pygame.time.Clock()
    ejecutando = True
    input_activo = False  # Indica si el campo de entrada está activo
    texto_usuario = ""  # Almacena la entrada del usuario
    mensaje_error = ""  # Almacena mensajes de error
    estado_anterior = None  # Almacena el estado anterior del tablero para comparar cambios

    # Reiniciar el tablero al inicio
    screen.fill(VACIO)
    mostrar_mensaje(screen, "Reiniciando el tablero...")
    pygame.display.flip()
    reiniciar_tablero()  

    realizar_jugadas_automáticas()

    while ejecutando:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                ejecutando = False

            # Manejar eventos de teclado
            if event.type == pygame.KEYDOWN:
                if input_activo:
                    if event.key == pygame.K_RETURN:  # Enter presionado
                        try:
                            posicion = int(texto_usuario)
                            if posicion in posibles_tiradas:
                                estado = realizar_jugada(posicion, "N")
                                if not estado:
                                    mensaje_error = "Error al realizar la jugada."
                                else:
                                    input_activo = False  # Desactivar el campo de entrada
                                    texto_usuario = ""  # Limpiar la entrada
                                    mensaje_error = ""  # Limpiar el mensaje de error
                            else:
                                mensaje_error = "Posición no válida. Intenta nuevamente."
                        except ValueError:
                            mensaje_error = "Entrada no válida. Introduce un número."
                        texto_usuario = ""  # Limpiar la entrada después de procesarla
                    elif event.key == pygame.K_BACKSPACE:  # Retroceso presionado
                        texto_usuario = texto_usuario[:-1]  # Eliminar el último carácter
                    else:
                        # Agregar el carácter ingresado al texto del usuario
                        if event.unicode.isdigit():  # Solo permitir números
                            texto_usuario += event.unicode

        # Obtener el estado del tablero
        estado = obtener_estado()
        if not estado:
            screen.fill(VACIO)
            mostrar_mensaje(screen, "No se pudo obtener el estado del tablero. Saliendo...")
            pygame.display.flip()
            pygame.time.wait(3000) 
            ejecutando = False
            continue

        # Procesar el tablero en formato string a una lista de listas
        tablero_actual = procesar_tablero(estado["tableroActual"])

        # Obtener el número de fichas blancas y negras
        blancas = obtener_blancas()  # Llamar a la función para obtener fichas blancas
        negras = obtener_negras()    # Llamar a la función para obtener fichas negras

        # Verificar si el tablero está lleno (condición prioritaria)
        if blancas + negras == 64:
            ejecutando = False
            screen.fill(VACIO)
            dibujar_tablero(screen, tablero_actual) 
            
            # Mostrar el marcador (fichas blancas y negras)
            font = pygame.font.Font(None, 36)
            texto_marcador = font.render(f"Blancas: {blancas}  Negras: {negras}", True, NEGRO)
            screen.blit(texto_marcador, (INICIO_X, INICIO_Y + TAM_TABLERO * TAM_CASILLA + 20))  # Justo arriba del turno
            
            if blancas > negras:
                mostrar_mensaje(screen, "¡Blancas ganan! (Tablero lleno y más fichas)", y_offset=80)
            elif negras > blancas:
                mostrar_mensaje(screen, "¡Negras ganan! (Tablero lleno y más fichas)", y_offset=80)
            else:
                mostrar_mensaje(screen, "¡Empate! (Tablero lleno y fichas iguales)", y_offset=80)
            pygame.display.flip()
            pygame.time.wait(3000) 
            continue

        # Verificar si un jugador se queda sin movimientos
        posibles_tiradas_blancas = obtener_posibles_tiradas("B")
        posibles_tiradas_negras = obtener_posibles_tiradas("N")
        turno_jugador = estado["turnoJugador"]


        if turno_jugador == "N" and not posibles_tiradas_negras:
            # Negras no tienen movimientos, Blancas ganan
            ejecutando = False
            screen.fill(VACIO)
            dibujar_tablero(screen, tablero_actual) 
            mostrar_mensaje(screen, "¡Blancas ganan! (Negras sin movimientos)", y_offset=80)
            pygame.display.flip()
            pygame.time.wait(3000) 
            continue

        if turno_jugador == "B" and not posibles_tiradas_blancas:
            # Blancas no tienen movimientos, Negras ganan
            ejecutando = False
            screen.fill(VACIO)
            dibujar_tablero(screen, tablero_actual) 
            mostrar_mensaje(screen, "¡Negras ganan! (Blancas sin movimientos)", y_offset=80)
            pygame.display.flip()
            pygame.time.wait(3000) 
            continue

        # Redibujar la pantalla
        screen.fill(VACIO)
        dibujar_tablero(screen, tablero_actual)

        # Mostrar el marcador (fichas blancas y negras)
        font = pygame.font.Font(None, 36)
        texto_marcador = font.render(f"Blancas: {blancas}  Negras: {negras}", True, NEGRO)
        screen.blit(texto_marcador, (INICIO_X, INICIO_Y + TAM_TABLERO * TAM_CASILLA + 20))

        # Mostrar el turno actual
        if turno_jugador == "N":
            mostrar_mensaje(screen, f"Turno de Negras...", y_offset=40)
        elif turno_jugador == "B":
            mostrar_mensaje(screen, f"Turno de Blancas...", y_offset=40)

        if "Ganador" in turno_jugador:
            screen.fill(VACIO)
            dibujar_tablero(screen, tablero_actual) 
            mostrar_mensaje(screen, turno_jugador, y_offset=80)
            pygame.display.flip()
            pygame.time.wait(3000) 
            ejecutando = False
            continue

        if turno_jugador == "N":  # Turno del jugador humano
            posibles_tiradas = obtener_posibles_tiradas("N")
            if not posibles_tiradas:
                mostrar_mensaje(screen, "No hay jugadas posibles para el jugador Negro. Pasando turno...", y_offset=80)
                pygame.display.flip()
                pygame.time.wait(2000)  # Esperar 2 segundos
                estado = realizar_jugada(-1, "N")  # Pasar turno
                if not estado:
                    mostrar_mensaje(screen, "Error al pasar el turno. Saliendo...", y_offset=80)
                    pygame.display.flip()
                    pygame.time.wait(3000) 
                    ejecutando = False
                continue

            mostrar_posibles_tiradas(screen, posibles_tiradas)

            # Activar el campo de entrada si no está activo
            if not input_activo:
                input_activo = True
                texto_usuario = ""
                mensaje_error = ""

            # Mostrar la entrada del usuario
            texto_input = font.render(f"Selecciona una posición: {texto_usuario}", True, BLANCO)
            screen.blit(texto_input, (INICIO_X, INICIO_Y + TAM_TABLERO * TAM_CASILLA + 100))

            # Mostrar mensajes de error
            if mensaje_error:
                mostrar_mensaje(screen, mensaje_error, y_offset=120)
        else:  # Turno de la computadora (B)
            mostrar_mensaje(screen, "La computadora (B) está calculando su jugada...", y_offset=80)
            pygame.display.flip()
            pygame.time.wait(1000)  # Simular tiempo de cálculo
            estado = realizar_jugada_computadora()
            if not estado:
                mostrar_mensaje(screen, "Error al realizar la jugada de la computadora. Saliendo...", y_offset=80)
                pygame.display.flip()
                pygame.time.wait(3000) 
                ejecutando = False

        pygame.display.flip()  # Actualizar la pantalla
        clock.tick(30)  # Limitar la velocidad de fotogramas

    pygame.quit()
    
if __name__ == "__main__":
    main()