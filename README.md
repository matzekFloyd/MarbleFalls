# Marble Falls

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A small physics-style game where you **spawn marbles** by touching a screen; marbles fall, bounce off the playfield, and interact with **moving edges** (score bonuses, penalties, or deflections). The original setup pairs an **Arduino** touch shield with **Processing** over USB serial.

## Hardware

- **Arduino**: sketch targets a **3.2" TFT LCD shield with touch** (ArduCAM touch stack; firmware lives under `arduino/MarbleFallsTouch/`).
- **Host PC**: runs **Processing 3** (or compatible) with the **Serial** library; connects to the Arduino at **9600 baud**.

## Coordinate format (serial)

The Arduino sends one line per touch burst, ASCII:

- Pattern: `X` + four digit characters + `Y` + four digit characters + newline (`\n`).
- Example: `X0801Y0875` means X = 801, Y = 875 (leading zeros pad values below 1000).

Processing reads a line in `serialEvent` and parses with `substring` (Processing’s end index is **exclusive**): X uses `substring(1, 5)` (four digits after `X`). Y uses `substring(7, 10)` in the current sketch (three digits after the first digit following `Y`); if you need the full four-digit Y, widen that range (for example `substring(6, 10)` for `X0801Y0875`).

The Processing sketch maps raw touch ranges **approximately 150–1800** (X and Y) into the sketch window; calibration can differ per shield—adjust the `map(...)` calls in the main `.pde` if needed.

## How to run

### Arduino

1. Open `arduino/MarbleFallsTouch/MarbleFallsTouch.ino` in the Arduino IDE (or PlatformIO if you port it). The sketch folder name matches the `.ino` basename, as required by the Arduino IDE.
2. Select the correct board and port; install dependencies for **ArduCAM_Touch** and **SD** as required by your shield docs.
3. Upload; the board streams touch coordinates over serial at **9600 baud**.

### Processing

1. Install [Processing](https://processing.org/) with default modes (Java mode).
2. Open the sketch folder `processing/MarbleFalls/` (main tab `MarbleFalls.pde` plus `GameConfig`, `Marble`, `Edge`, `Timer`).
3. Set the serial port: adjust **`SERIAL_PORT_INDEX`** at the top of `MarbleFalls.pde` so it matches your Arduino’s entry in `Serial.list()` (default is `3`).
4. Run the sketch. With a working serial link, touches from the Arduino spawn marbles like before.

### Verify without Arduino

If opening serial fails or there is no port at `SERIAL_PORT_INDEX`, the sketch still starts and prints a short message to the **Processing console**. Use **mouse mode**: click in the **upper half** of the window (same region as touch-mapped spawns) to drop marbles and confirm the sim loop, edges, and collisions behave as expected.

### Web (p5.js + TypeScript)

The browser build lives in `web/`. It uses **npm** for **p5** (no CDN), **Vite** to bundle, and **TypeScript** so the sketch lines up with **`@types/p5`**: you get autocomplete and compile-time checks on the p5 instance API. The game runs in **p5 instance mode** (`new p5(...)`) so it works as ES modules with Vite; the same logic as the Processing port (edges, scoring, collisions, timed spawns). Input is **mouse or touch** in the upper half of the canvas (no USB serial in the browser).

```bash
cd web
npm install
npm run dev
```

Open the URL Vite prints (usually `http://localhost:5173/`). Production build:

```bash
npm run build
npm run preview   # optional local check of dist/
```

Output is `web/dist/` — deploy that folder to static hosting. Tune parameters in `web/src/gameConfig.ts` (same fields as `GameConfig.pde`).

**Netlify:** connect the repo and use the defaults; [`netlify.toml`](netlify.toml) sets **base directory** `web`, **build command** `npm run build`, and **publish directory** `dist` (relative to `web`, so `web/dist` on disk). Netlify runs `npm install` in `web/` before the build. Optional: set a custom domain in Site settings → Domain management.

## Repository layout

| Path | Role |
|------|------|
| `arduino/MarbleFallsTouch/` | Touch reader firmware → USB serial |
| `processing/MarbleFalls/` | Game sketch: `GameConfig`, serial/mouse input, marbles, edges, score, timer |
| `web/` | Vite + TypeScript + **p5**; `npm run dev` / `npm run build` → `dist/` |
| `netlify.toml` | Netlify: base `web`, publish `web/dist/` |

## License

This project is licensed under the [MIT License](LICENSE).
