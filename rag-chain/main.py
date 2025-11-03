import os
import uvicorn

SOCKET_PATH = "/sockets/rag.sock"

if __name__ == "__main__":
    uvicorn.run("app.api.server:app", uds=SOCKET_PATH, reload=False, workers=1)
