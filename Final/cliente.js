const API_URL = "http://localhost:3000";

async function getBoard() {
  const response = await fetch(`${API_URL}/board`);
  const board = await response.json();
  renderBoard(board);
}

async function playMove(position) {
  const response = await fetch(`${API_URL}/play`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ pos: position }),
  });
  const updatedBoard = await response.json();
  renderBoard(updatedBoard);
}

function renderBoard(board) {
  const grid = document.getElementById("grid");
  grid.innerHTML = ""; // Limpia el tablero actual

  board.forEach(({ pos, tipo }) => {
    const cell = document.createElement("div");
    cell.className = "cell";
    cell.dataset.position = pos;
    cell.textContent = tipo === "E" ? "." : tipo;
    cell.addEventListener("click", () => playMove(pos));
    grid.appendChild(cell);
  });
}

document.addEventListener("DOMContentLoaded", () => getBoard());
