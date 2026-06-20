# CLAUDE.md

## Project Overview

**terminal-app** is an interactive web portfolio that looks and behaves like a real Linux terminal. Users type commands to learn about Eliel. The live site is at elielberra.com (also available on Tor).

Three main services, all containerized via Docker Compose:
1. **terminal-app** — Go WebSocket server + PTY + static frontend (xterm.js) + Bash scripts
2. **rag-chain** — Python FastAPI microservice powering the AI chatbot
3. **nginx** — Reverse proxy (HTTP dev / HTTPS+Tor prod)

---

## Repository Structure

```
terminal-app/
├── terminal-app/          # Go backend + frontend + Bash logic
│   ├── main.go            # WebSocket server, PTY spawning
│   ├── static/            # Vanilla JS frontend (xterm.js)
│   │   └── js/            # terminal.js, signalHandler.js, events.js, vars.js
│   └── scripts/           # Bash terminal logic
│       ├── eliel.sh       # Main command dispatcher
│       ├── chatbot.sh     # Chatbot via Unix socket to rag-chain
│       ├── arg-fnc-video.sh
│       └── ...
├── rag-chain/             # Python microservice
│   ├── main.py            # Uvicorn entry point (Unix socket or TCP)
│   └── app/
│       ├── api/server.py  # FastAPI routes: /ask /locate /conversation
│       ├── rag/chain.py   # LangGraph RAG pipeline (retrieve → generate)
│       ├── db/store.py    # SQLite persistence (conversations table)
│       ├── vector_store/  # NumPy embeddings + cosine similarity search
│       └── utils/         # Gemini client, IP geolocation
├── nginx/                 # nginx.conf.dev / nginx.conf.prod
├── apparmor/terminal-app  # AppArmor security profile
├── docker-compose-dev.yaml
├── docker-compose-prod.yaml
├── dev-restart.sh         # Full dev rebuild + browser launch
└── prod-restart.sh        # Production restart
```

---

## Development Workflow

### Start Dev Environment

```bash
./dev-restart.sh
```

This script:
1. Brings down existing containers
2. Builds the Go binary: `go build -o terminal-app main.go` (inside `terminal-app/`)
3. Sets binary permissions: `chmod 0100`, `chown 1000:1000`, `setcap cap_setuid,cap_setgid+ep`
4. Reloads the AppArmor profile
5. Brings up containers with live source mounts
6. Opens Chrome at http://localhost when healthy

### Stop/Rebuild

```bash
docker compose -f docker-compose-dev.yaml down
```

### Rebuild a single service

```bash
docker compose -f docker-compose-dev.yaml up --build rag-chain
```

### View logs

```bash
docker compose -f docker-compose-dev.yaml logs -f terminal-app
docker compose -f docker-compose-dev.yaml logs -f rag-chain
```

---

## Key Architecture Details

### WebSocket + PTY (Go)

`terminal-app/main.go` listens on port 8080. On `/ws`:
1. Extracts user language from `Accept-Language` header → sets `USER_LANG` env var
2. Extracts user IP from `X-Real-IP` or remote address → sets `USER_IP`
3. Spawns `/bin/rbash --rcfile /home/web-user/.bashrc -i` as `web-user` (UID 1001)
4. Creates a PTY; bidirectional relay between PTY output and WebSocket binary frames
5. Resize messages from the client are JSON: `{"type":"resize","cols":N,"rows":N}`

### Signal Protocol (Bash → Frontend)

Bash scripts emit special string signals that `signalHandler.js` intercepts. The signal is prefixed to binary WebSocket messages. Key signals:

| Signal | Effect |
|--------|--------|
| `SIG_DISABLE_TERMINAL_INPUT` | Locks keyboard input |
| `SIG_ENABLE_TERMINAL_INPUT` | Restores keyboard input |
| `SIG_PLAY_GLADIATOR_MUSIC` | Plays background audio |
| `SIG_AUGMENT_FONT_SIZE` | Enlarges terminal font |
| `SIG_REDUCE_FONT_SIZE` | Shrinks font |
| `SIG_DEFAULT_FONT_SIZE` | Resets font |
| `SIG_OPEN_CV_ENG` / `SIG_OPEN_CV_ESP` | Opens CV PDF modal |
| `SIG_DISPLAY_THEME_BTN` | Shows dark/light toggle |
| `SIG_SHOW_CLOSE_VIDEO_BTN` | Shows video close button |

### Inter-Container Communication

terminal-app ↔ rag-chain communicate via **Unix socket** at `/sockets/rag.sock` (Docker named volume `rag_sock`). No TCP exposure, not even on the internal Docker network.

`chatbot.sh` uses `curl --unix-socket /sockets/rag.sock`:
- `GET  http://localhost/locate?ip=<ip>` — geolocate user
- `POST http://localhost/ask` — send question, get AI answer
- `POST http://localhost/conversation` — save full conversation on exit

### RAG Chain Pipeline

`rag/chain.py` uses **LangGraph** with two nodes:
1. **retrieve** — cosine similarity search over NumPy embeddings (`store/store_embeddings.npy`)
2. **generate** — Google Gemini `gemini-2.5-flash-lite` with injected context

Source data is `rag-chain/data/eliel.txt` (CV in Markdown). Embeddings use `gemini-embedding-2`.

To regenerate embeddings after updating `eliel.txt`, run the vector store build logic in `vector_store/vector_store.py`.

### SQLite Database

`db/store.py` uses Python's stdlib `sqlite3` (no external dependency). Database file at `rag-chain/store/conversations.db`.

Schema:
```sql
CREATE TABLE conversations (
    session_id TEXT      PRIMARY KEY,
    content    TEXT      NOT NULL,
    ip         TEXT,
    location   TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

### Multilingual Support

`USER_LANG` env var is set by the Go backend and available to all Bash scripts. Scripts check `$USER_LANG` to display Spanish or English text. The frontend also uses it for chatbot prompts.

---

## Environment Variables

### terminal-app

| Variable | Dev value | Description |
|----------|-----------|-------------|
| `WEBSOCKET_PROTOCOL` | `http` | `http` or `https` |
| `DOMAIN` | `localhost` | Public domain |
| `APP_PORT` | `8080` | Go server port |

### rag-chain

| Variable | Description |
|----------|-------------|
| `GOOGLE_API_KEY` | Required. Google AI Studio API key |
| `LOCAL_SECURITY_TESTING` | Set to `true` to expose TCP port 5000 instead of Unix socket |
| `SQLITE_DB_PATH` | Path to SQLite file (default: `/rag-chain/store/conversations.db`) |

The rag-chain `.env` file is gitignored. See `.env-dummy` for required keys.

---

## Security Constraints

These constraints exist by design — do not work around them:

- **rbash**: No `cd`, no PATH changes, no setting env vars, no redirects to files
- **AppArmor**: Only a whitelist of executables is permitted (`apparmor/terminal-app`). Any new command needed in scripts must be added to this profile and the profile reloaded
- **Read-only containers**: No runtime file writes except tmpfs mounts (GPG dir) and the socket volume
- **No root**: `sudo` is disabled; the Go binary uses `setcap` for `setuid`/`setgid` only
- **No outbound TCP**: iptables rules (`iptables-rules.sh`) block all outbound internet traffic from the terminal-app container

When adding new commands or scripts, check `apparmor/terminal-app` — new executables need an explicit allow rule.

---

## Frontend (Vanilla JS + xterm.js)

Files live in `terminal-app/static/js/`. Key files:

- `terminal.js` — xterm Terminal instance, WebSocket connection, message routing
- `signalHandler.js` — maps `SIG_*` strings to DOM/audio actions
- `events.js` — DOM event listeners (theme toggle, resize, close-video button)
- `vars.js` — font size states, viewport breakpoints, CV URLs, session tracking

The frontend is served directly by the Go HTTP server (`http.FileServer`). No build step required.

---

## No Tests

The project has no automated test suite. Manual testing via the browser is the only way to verify changes. Use `./dev-restart.sh` and test in the terminal at http://localhost.

---

## Production Deployment

Runs on an AWS EC2 instance (Debian, ARM64). `prod-restart.sh`:
1. Links `apparmor/terminal-app` to `/etc/apparmor.d/`
2. Reloads AppArmor
3. Brings up containers with `docker-compose-prod.yaml` (no live mounts, read-only, port 443)

The Go binary in prod is cross-compiled for ARM64 in a multi-stage Dockerfile.

---

## Garak (LLM Security Testing)

`garak/` contains configuration and results for [Garak](https://github.com/NVIDIA/garak) LLM probe tests, used to test jailbreak resistance of the chatbot. Not part of the main app — ignore when working on features.
