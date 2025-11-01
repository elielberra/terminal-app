import sys
from app.rag.chain import run_once
from app.rag.chain import build_app
import uvicorn

if __name__ == "__main__":
    question = " ".join(sys.argv[1:]) or "Cuál es el trabajo actual de Eliel?"
    print(run_once(question))

    # print("🔧 Initializing RAG graph...")
    # rag = build_app()
    # print("🚀 Starting FastAPI server on http://localhost:5000 ...")
    # uvicorn.run("app.api.server:app", host="0.0.0.0", port=5000, reload=True)

