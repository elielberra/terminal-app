# Local Development Setup

Instructions for Debian/Ubuntu. Adjust package manager commands for your own OS as needed.

---

## Dependencies

Install the required system packages:

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-v2 golang wmctrl google-chrome-stable
```

Add your user to the Docker group so you can run containers without `sudo`. A full logout and back in is required for this to take effect permanently:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## AppArmor profile

The `terminal-app` container runs under a custom AppArmor profile. Load it once before running the app:

```bash
sudo cp apparmor/terminal-app /etc/apparmor.d/terminal-app
sudo apparmor_parser -r -W /etc/apparmor.d/terminal-app
```

---

## Environment variables

The `rag-chain` service requires a Google AI Studio API key. Copy the dummy file and fill in your key:

```bash
cp rag-chain/.env-dummy rag-chain/.env
```

Then open `rag-chain/.env` and set `GOOGLE_API_KEY` to your key. To get one, go to <a href="https://aistudio.google.com/apikey" target="_blank">Google AI Studio</a>, sign in with a Google account, and create a new API key. It is free for standard usage.

Leave `LOCAL_SECURITY_TESTING=false` unless you are running Garak security tests locally (see `garak/SETUP.md`).

---

## Running the app

Use the dev restart script, which builds the Go binary, reloads the AppArmor profile, starts the Docker containers, and opens Chrome automatically:

```bash
bash dev-restart.sh
```

The first run will build the Docker images, which takes a few minutes. Subsequent runs are faster. Logs from all containers stream directly to the terminal. The app is available at `http://localhost`.

---

## Vector store

The RAG chain requires a pre-built vector store. If it is missing or you update `rag-chain/data/eliel.txt`, rebuild it by running inside the `rag-chain` container:

```bash
docker exec -it rag-chain sh -c "PYTHONPATH=/rag-chain python app/vector_store/vector_store.py build"
```
