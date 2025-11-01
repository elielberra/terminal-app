# rag-chain/main.py
import os
import uvicorn

SOCKET_PATH = "/sockets/rag.sock"

if __name__ == "__main__":
    if os.path.exists(SOCKET_PATH):
        os.remove(SOCKET_PATH)
    uvicorn.run("app.api.server:app", uds=SOCKET_PATH, reload=False, workers=1)
