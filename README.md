# Terminal App

## Index
1. [Overview](#overview)  
2. [Backend](#backend)  
3. [Frontend](#frontend)  
4. [Terminal Logic (Bash)](#terminal-logic-bash)  
5. [Nginx Proxy](#nginx-proxy)  
6. [Deployment](#deployment)
7. [Cybersecurity](#cybersecurity)

---

## Overview
The idea behind this project is to offer an alternative and more creative way for people to get to know who I am. The **terminal-app** is an interactive web application that looks and behaves like a real Linux terminal. Unlike a traditional web app with buttons or menus, the entire user experience happens inside the terminal. As the user types different commands, they can learn more about me and discover various hidden surprises built into the system. The app is hosted at <a href="https://elielberra.com" target="_blank">www.elielberra.com</a>.

---

## Backend
The backend is written in **Go** and handles the logic behind the terminal. It uses **Gorilla WebSocket** to maintain a real-time connection between the browser and the server. When a user types a command, the backend spawns a **pseudo-terminal (PTY)** that runs inside a restricted shell. The output from this PTY is sent back through the WebSocket so that everything appears live in the browser.

---

## Frontend
The frontend is built with **HTML, CSS, and vanilla JavaScript**. There isn’t a typical user interface, so a framework wasn’t necessary — everything happens inside the terminal window. The frontend’s code is located inside the backend’s **static** folder, where it is served directly by the Go server. The terminal view is powered by <a href="https://github.com/xtermjs/xterm.js" target="_blank">xterm js</a>, which handles user input, colors, and cursor movement. The connection to the backend through the WebSocket makes the terminal respond in real time. Different signals sent from the backend can change how the terminal looks or behaves — for example, enabling or disabling typing, blinking the cursor, or triggering sounds and animations.

### Features
- The terminal is fully responsive, and the text size automatically adjusts to different devices.
- You can switch between dark and light themes at any time.  
- Background server sounds create an immersive atmosphere and can be muted if preferred.
- The interface supports real typing, cursor movement, and colorized output through **xterm.js**.
- Commands trigger animations, music, or other effects, making the experience dynamic and interactive.

### Limitations
- A terminal is meant to be used on a PC. Using it from a phone is uncomfrotable. On top of that, the developers of xterm didn't provide a lot of support for mobile and that makes it posibilities limited, you might experience issues with scrolling or other features. As mentioned in a <a href="https://github.com/xtermjs/xterm.js/issues/5377#issuecomment-3094609703 " target="_blank">GitHub issue</a>, the xterm.js maintainers do not plan to address these mobile limitations in the future.

---

## Terminal Logic (Bash)
While the backend server is written in **Go**, the actual logic of the terminal-app is built entirely in **Bash**. Everything that happens inside the terminal, from the visual effects and command responses to the communication signals sent back to the frontend, is powered by Bash scripts. These scripts control how each command behaves, manage animations, and define how the app interacts with users in real time, making Bash the core engine behind the entire experience.

---

## Nginx Proxy
**Nginx** works as a reverse proxy that connects the frontend and backend. It serves the static files, forwards WebSocket traffic, and manages HTTPS connections with SSL certificates.

---

## Deployment
Every service in the terminal-app runs inside its own **Docker container**. The **Go backend** and the **Nginx proxy** are all containerized. The entire application is deployed and managed using **Docker Compose**, which handles service orchestration, networking, and environment configuration automatically.

A Bash script simplifies the deployment process for both development and production environments. In production, the app runs on an EC2 instance, where the script automatically sets up and launches all required services.

---

## Cybersecurity
Imagine you are a bank robber who is magically teleported straight into the vault without having to plan or break in. There is a big catch: your hands are tied, you cannot move, you cannot communicate with the outside world, and everything you try is strictly restricted. The biggest catch of all is that there is no money or database to steal. This is the idea behind the app: bring users directly into the web server while keeping them tightly confined. The challenge was to implement strict, draconian security controls but still allow the limited actions the user is supposed to perform.

### Containers
All the services run inside Docker containers to keep them isolated. The containers are read-only so files cannot be changed at runtime. It is not possible to become root with sudo. Docker drops most Linux capabilities from processes inside the container, which prevents privileged actions like changing network interfaces, loading kernel modules, or switching user IDs. This limits what an attacker could do even if they run code inside the container.

### AppArmor
An <a href="https://apparmor.net/" target="_blank">AppArmor</a> profile is applied through Docker’s security options to strictly control what the terminal can do. It heavily restricts access to the file system, allowing only specific files and directories to be read. It also defines a small set of permitted commands while blocking every other possible action. This ensures that even if a user tries to execute something unexpected, the command will be denied by the system.

### Restricted Bash (rbash)
The terminal runs under <a href="https://www.gnu.org/software/bash/manual/html_node/The-Restricted-Shell.html" target="_blank">rbash</a>, a restricted version of the Bash shell. It prevents users from changing directories, setting environment variables, modifying the PATH, or running commands outside of approved locations. This keeps the user confined to a controlled environment where only safe, predefined actions are allowed.

### Networking
The terminal-app is enclosed within a private internal network that has no direct access to the internet. This isolation ensures that even if someone tries to exploit the system from within the terminal, there is no route to reach external servers or services.  
In front of the application sits an **Nginx proxy**, which acts as the only entry and exit point. It filters all traffic, routes only the allowed requests, and adds another layer of protection between the user and the backend. This setup minimizes exposure and keeps the internal components completely unreachable from the outside world.
This setup is probably overkill since the network is already private, but additional iptables rules are also in place to block any outgoing traffic to the external internet, ensuring that nothing inside the container can ever reach outside.
