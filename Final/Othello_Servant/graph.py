import pygame
from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
import numpy as np

# Definir los colores para las piezas
NEGRO = (0.0, 0.0, 0.0)
BLANCO = (1.0, 1.0, 1.0)
VACIO = (0.5, 0.5, 0.5)

# Definir las dimensiones del tablero
TAM_TABLERO = 8
TAM_CASILLA = 1.0
INICIO_X = -4.0
INICIO_Y = -4.0

# Representación del tablero
# Tablero 8x8 con las piezas en las posiciones iniciales (solo ejemplo)
tablero = [
    [VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO],
    [VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO],
    [VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO],
    [VACIO, VACIO, VACIO, BLANCO, NEGRO, VACIO, VACIO, VACIO],
    [VACIO, VACIO, VACIO, NEGRO, BLANCO, VACIO, VACIO, VACIO],
    [VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO],
    [VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO],
    [VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO, VACIO]
]

# Función para dibujar un rectángulo (casilla)
def dibujar_casilla(x, y, color):
    glBegin(GL_QUADS)
    glColor3fv(color)
    glVertex2f(x, y)
    glVertex2f(x + TAM_CASILLA, y)
    glVertex2f(x + TAM_CASILLA, y + TAM_CASILLA)
    glVertex2f(x, y + TAM_CASILLA)
    glEnd()

# Función para dibujar las piezas (círculos)
def dibujar_pieza(x, y, color):
    num_segments = 100
    radius = TAM_CASILLA / 2 * 0.8
    glBegin(GL_POLYGON)
    glColor3fv(color)
    for i in range(num_segments):
        angle = 2 * np.pi * i / num_segments
        dx = radius * np.cos(angle)
        dy = radius * np.sin(angle)
        glVertex2f(x + dx, y + dy)
    glEnd()

# Función para dibujar el tablero completo
def dibujar_tablero():
    for i in range(TAM_TABLERO):
        for j in range(TAM_TABLERO):
            x = INICIO_X + j * TAM_CASILLA
            y = INICIO_Y + i * TAM_CASILLA
            dibujar_casilla(x, y, (0.0, 0.0, 0.0))  # Color de fondo de la casilla
            if tablero[i][j] != VACIO:
                dibujar_pieza(x + TAM_CASILLA / 2, y + TAM_CASILLA / 2, tablero[i][j])

# Función para manejar eventos de clic
def manejar_eventos():
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            quit()

        if event.type == pygame.MOUSEBUTTONDOWN:
            x, y = pygame.mouse.get_pos()
            x = (x - 400) / 100
            y = (300 - y) / 100
            x = int(x)
            y = int(y)
            if 0 <= x < TAM_TABLERO and 0 <= y < TAM_TABLERO:
                print(f"Posición seleccionada: {x}, {y}")
                # Lógica para ejecutar la jugada en esa casilla

# Inicializar pygame y OpenGL
def init():
    pygame.init()
    display = (800, 600)
    pygame.display.set_mode(display, pygame.DOUBLEBUF | pygame.OPENGL)
    gluOrtho2D(-5, 5, -5, 5)  # Definir el espacio de coordenadas en 2D
    glClearColor(1, 1, 1, 1)  # Color de fondo (blanco)

# Función principal
def main():
    init()
    while True:
        glClear(GL_COLOR_BUFFER_BIT)
        manejar_eventos()
        dibujar_tablero()
        pygame.display.flip()

if __name__ == "__main__":
    main()
