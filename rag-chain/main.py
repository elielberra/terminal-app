import os
import threading
import uvicorn

SOCKET_PATH = "/sockets/rag.sock"

def _run_tcp(port: int):
    uvicorn.run("app.api.server:app", host="0.0.0.0", port=port, reload=False)

if __name__ == "__main__":
    if os.getenv("LOCAL_SECURITY_TESTING") == "true":
        threading.Thread(target=_run_tcp, args=(int(os.getenv("RAG_PORT", "5000")),), daemon=True).start()
    uvicorn.run("app.api.server:app", uds=SOCKET_PATH, reload=False, workers=1)
