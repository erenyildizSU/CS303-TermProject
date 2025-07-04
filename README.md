# CS303 - Term Project: Electronic Battleship Game (FPGA Implementation)

This repository contains the Verilog implementation of an **Electronic Battleship Game** designed as a term project for **CS303 - Logic & Digital System Design** (Fall 2024).

## 🎮 Project Overview

The aim of the project is to implement a two-player Battleship game using Verilog on an FPGA development board. Each player places their ships on a 4x4 grid, and players take turns trying to sink each other's ships. The system utilizes:

- **LEDs** to indicate turns, scores, and events.
- **7-Segment Displays (SSDs)** to display coordinates, scores, and game states.
- **Switches and Push Buttons** for user input.
- **FPGA clock and divided clocks** for synchronous control and debouncing.

## 🧩 Game Mechanics

- **Setup Phase:**
  - Players A and B place 4 ships each on a 4x4 grid by entering X-Y coordinates via switches.
  - Coordinates are input using 2 MSB switches (X) and 2 LSB switches (Y).
  - Errors are handled when overlapping coordinates are entered.

- **Gameplay Phase:**
  - Players take turns shooting coordinates to sink opponent's ships.
  - Score is updated and displayed in real time.
  - LEDs blink or stay off depending on hit/miss.
  - The first player to sink all 4 enemy ships wins the game.

- **Victory Phase:**
  - Final score and winner are shown on SSDs.
  - LEDs blink with a 1-second period to indicate game end.

## 🛠️ Files and Modules

| File             | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `top.v`          | Top-level Verilog module combining all submodules.                         |
| `battleship.v`   | Main logic of the Battleship game including state machine and gameplay.    |
| `clk_divider.v`  | Divides 100MHz board clock to 50Hz for synchronous operations.             |
| `debouncer.v`    | Handles mechanical bounce of push-buttons.                                 |
| `ssd.v`          | Drives the 4 seven-segment displays.                                        |

## 🧪 Testbench

A Verilog testbench is written to simulate a sample gameplay where:

- Both players place ships at same coordinates.
- Players take turns and one of them wins by sinking all four ships.
- The simulation validates state transitions, scorekeeping, and win detection.

> **Note:** Full testbench file (e.g. `battleship_tb.v`) is to be added manually if required.

## ⚙️ Tools & Technologies

- **Language:** Verilog HDL
- **Platform:** FPGA Board (e.g., Basys 3 or equivalent)
- **IDE:** Vivado / ModelSim (for simulation)
- **Clock Frequency:** 100MHz input, 50Hz divided clock

## 📅 Timeline

| Phase           | Deadline         | Weight  |
|----------------|------------------|---------|
| State Diagrams | Dec 15, 2024     | 10%     |
| Simulation     | Dec 24, 2024     | 30%     |
| FPGA Demo      | Jan 3, 2025      | 60%     |

## 📸 Visuals

| Component | Control |
|----------|---------|
| SSDs     | p-g-f-e-d-c-b-a (8-bit control per SSD) |
| LEDs     | Visual indication for state, score, win, turn |
| Buttons  | BTN3 (A), BTN0 (B), BTN2 (Reset), BTN1 (Start) |
| Switches | SW3-2 for X, SW1-0 for Y |

## 📂 Repository Structure

```bash
.
├── battleship.v
├── clk_divider.v
├── debouncer.v
├── ssd.v
├── top.v
└── README.md
