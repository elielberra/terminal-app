# Terminal App

## Index
1. [Overview](#overview)  
2. [Backend](#backend)  
3. [Frontend](#frontend)  
4. [Terminal Logic (Bash)](#terminal-logic-bash)  
5. [Nginx Proxy](#nginx-proxy)  
6. [Deployment](#deployment)

---

## Overview
The idea behind this project is to offer an alternative and more creative way for people to get to know who I am. The **terminal-app** is an interactive web application that looks and behaves like a real Linux terminal. Unlike a traditional web app with buttons or menus, the entire user experience happens inside the terminal. As the user types different commands, they can learn more about me and discover various hidden surprises built into the system. The app is hosted at [www.elielberra.com](https://elielberra.com).

---

## Backend
The backend is written in **Go** and handles the logic behind the terminal. It uses **Gorilla WebSocket** to maintain a real-time connection between the browser and the server. When a user types a command, the backend spawns a **pseudo-terminal (PTY)** that runs inside a restricted shell. The output from this PTY is sent back through the WebSocket so that everything appears live in the browser.

---

## Frontend
The frontend is built with **HTML, CSS, and vanilla JavaScript**. There isn’t a typical user interface, so a framework wasn’t necessary — everything happens inside the terminal window. The frontend’s code is located inside the backend’s **static** folder, where it is served directly by the Go server. The terminal view is powered by [**xterm.js**](https://github.com/xtermjs/xterm.js), which handles user input, colors, and cursor movement. The connection to the backend through the WebSocket makes the terminal respond in real time. Different signals sent from the backend can change how the terminal looks or behaves — for example, enabling or disabling typing, blinking the cursor, or triggering sounds and animations.

---

## Terminal Logic (Bash)
While the backend server is written in **Go**, the actual logic of the terminal-app is built entirely in **Bash**. Everything that happens inside the terminal, from the visual effects and command responses to the communication signals sent back to the frontend, is powered by Bash scripts. These scripts control how each command behaves, manage animations, and define how the app interacts with users in real time, making Bash the core engine behind the entire experience.

---

## Nginx Proxy
**Nginx** works as a reverse proxy that connects the frontend and backend. It serves the static files, forwards WebSocket traffic, and manages HTTPS connections with SSL certificates.

---

## Deployment
Every service in the terminal-app runs inside its own **Docker container**. The **Go backend** and the **Nginx proxy** are all containerized. The entire application is deployed and managed using **Docker Compose**, which handles service orchestration, networking, and environment configuration automatically.
