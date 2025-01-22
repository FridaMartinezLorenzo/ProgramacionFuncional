import pygame
from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
import numpy as np
from math import cos, sin

import requests 

#Funciones del servidor# Función para obtener el estado actual del juego desde el servidor
def obtener_estado():
    url = "http://localhost:8080/estado"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        tablero_servidor = data["tableroActual"]
        tablero_matriz = convertir_a_matriz(tablero_servidor)
        return tablero_matriz, data["turnoJugador"]
    return None, None



# Función para hacer una jugada en el servidor
def realizar_jugada(pos, jugador):
    url = "http://localhost:8080/jugada"
    data = {"posicion": pos, "jugador": jugador}
    response = requests.post(url, json=data)
    if response.status_code == 200:
        data = response.json()
        return data["tableroActual"], data["turnoJugador"]
    return None, None

#Graficos

# Colores
NEGRO = (0.0, 0.0, 0.0)
BLANCO = (1.0, 1.0, 1.0)
VACIO = (0.5, 0.5, 0.5)
VERDE = (0.0, 0.5, 0.0)

# Dimensiones del tablero
TAM_TABLERO = 8
TAM_CASILLA = 1.0
INICIO_X = -4.0
INICIO_Y = -4.0

def dibujar_casilla(x, y):
    """Dibuja una casilla verde con contorno."""
    glColor3f(*VERDE)
    glBegin(GL_QUADS)
    glVertex2f(x, y)
    glVertex2f(x + TAM_CASILLA, y)
    glVertex2f(x + TAM_CASILLA, y + TAM_CASILLA)
    glVertex2f(x, y + TAM_CASILLA)
    glEnd()

    # Dibujar el contorno (grid)
    glColor3f(0, 0, 0)  # Color del grid (negro)
    glBegin(GL_LINE_LOOP)
    glVertex2f(x, y)
    glVertex2f(x + TAM_CASILLA, y)
    glVertex2f(x + TAM_CASILLA, y + TAM_CASILLA)
    glVertex2f(x, y + TAM_CASILLA)
    glEnd()

def dibujar_pieza(x, y, color):
    """Dibuja una pieza circular en el tablero."""
    glColor3f(*color)
    glBegin(GL_POLYGON)
    for i in range(36):
        angulo = 2 * 3.14159 * i / 36
        glVertex2f(x + 0.4 * TAM_CASILLA * cos(angulo), y + 0.4 * TAM_CASILLA * sin(angulo))
    glEnd()

def dibujar_tablero(tablero):
    """Dibuja el tablero con todas las casillas y piezas."""
    for i in range(TAM_TABLERO):
        for j in range(TAM_TABLERO):
            x = INICIO_X + j * TAM_CASILLA
            y = INICIO_Y + i * TAM_CASILLA
            dibujar_casilla(x, y)  # Dibujar casilla verde con grid
            if tablero[i][j] != VACIO:  # Si hay pieza, dibujarla
                dibujar_pieza(x + TAM_CASILLA / 2, y + TAM_CASILLA / 2, tablero[i][j])

def init():
    """Inicializa Pygame y OpenGL."""
    pygame.init()
    display = (800, 600)
    pygame.display.set_mode(display, pygame.DOUBLEBUF | pygame.OPENGL)
    gluOrtho2D(-5, 5, -5, 5)  # Define el espacio de coordenadas 2D
    glClearColor(1, 1, 1, 1)  # Color de fondo blanco

def main():
    """Función principal para mostrar el tablero."""
    init()
    tablero_prueba = [
        [VACIO, NEGRO, BLANCO, VACIO, VACIO, BLANCO, NEGRO, VACIO],
        [VACIO] * 8,
        [VACIO] * 8,
        [VACIO] * 8,
        [VACIO] * 8,
        [VACIO] * 8,
        [VACIO] * 8,
        [VACIO, BLANCO, VACIO, NEGRO, VACIO, NEGRO, BLANCO, VACIO],
    ]
    while True:
        glClear(GL_COLOR_BUFFER_BIT)
        dibujar_tablero(tablero_prueba)  # Dibujar el tablero de prueba
        pygame.display.flip()
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                quit()

if __name__ == "__main__":
    main()