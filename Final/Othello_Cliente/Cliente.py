import requests

# URL base del servidor Haskell
BASE_URL = "http://localhost:8080"

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

def reiniciar_tablero():
    """Reinicia el tablero en el servidor."""
    try:
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

def jugar():
    """Función principal para manejar el juego."""
    print("Reiniciando el tablero...")
    reiniciar_tablero()  # Reiniciar el tablero al inicio

    while True:
        print("\nObteniendo estado del tablero...")
        estado = obtener_estado()

        if not estado:
            print("No se pudo obtener el estado del tablero. Saliendo...")
            break

        tablero_actual = estado["tableroActual"]
        turno_jugador = estado["turnoJugador"]

        print("\nTablero actual:")
        mostrar_tablero(tablero_actual)

        if "No es tu turno" in turno_jugador or "Movimiento inválido" in turno_jugador:
            print(turno_jugador)
            continue  # Este ciclo se sigue ejecutando si no es el turno del jugador

        print(f"Turno de: {turno_jugador}")

        if turno_jugador == "N":  # Turno del jugador humano
            # Obtener las posibles tiradas para el jugador humano
            posibles_tiradas = obtener_posibles_tiradas("N")
            if not posibles_tiradas:
                print("No hay jugadas posibles para el jugador Negro. Pasando turno...")
                estado = realizar_jugada(-1, "N")  # Pasar turno
                if not estado:
                    print("Error al pasar el turno. Saliendo...")
                    break
                continue  # Aquí se asegurará de que el ciclo siga con el turno de la otra persona

            print("Posibles tiradas:", posibles_tiradas)
            try:
                posicion = int(input("Selecciona una posición para hacer tu jugada (número de casilla): "))
                if posicion not in posibles_tiradas:
                    print("Posición no válida. Intenta nuevamente.")
                    continue
                estado = realizar_jugada(posicion, "N")
                if not estado:
                    print("Error al realizar la jugada. Saliendo...")
                    break
            except ValueError:
                print("Entrada no válida. Introduce un número.")
        else:  # Turno de la computadora (B)
            print("La computadora (B) está calculando su jugada...")
            estado = realizar_jugada_computadora()  # Llamar al endpoint específico para la jugada de la computadora
            if not estado:
                print("Error al realizar la jugada de la computadora. Saliendo...")
                break

        # Verificar si el juego ha terminado
        if "Ganador" in estado["turnoJugador"]:
            print(estado["turnoJugador"])
            break

if __name__ == "__main__":
    jugar()

#Graficos ____________________________________________________________________________________________________________-----
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


def dibujar_casilla(screen, x, y):
    """Dibuja una casilla verde con contorno."""
    pygame.draw.rect(screen, VERDE, (x, y, TAM_CASILLA, TAM_CASILLA))
    pygame.draw.rect(screen, NEGRO, (x, y, TAM_CASILLA, TAM_CASILLA), 1)


def dibujar_pieza(screen, x, y, color):
    """Dibuja una pieza circular en el tablero."""
    pygame.draw.circle(screen, color, (x + TAM_CASILLA // 2, y + TAM_CASILLA // 2), TAM_CASILLA // 2 - 5)


def dibujar_tablero(screen, tablero):
    """Dibuja el tablero con todas las casillas y piezas."""
    for i in range(TAM_TABLERO):
        for j in range(TAM_TABLERO):
            x = INICIO_X + j * TAM_CASILLA
            y = INICIO_Y + i * TAM_CASILLA
            dibujar_casilla(screen, x, y)  # Dibujar casilla verde con grid
            if tablero[i][j] != VACIO:  # Si hay pieza, dibujarla
                dibujar_pieza(screen, x, y, tablero[i][j])


