import sys
from app.rag.chain import run_once

if __name__ == "__main__":
    question = " ".join(sys.argv[1:]) or "Cuál es el trabajo actual de Eliel?"
    print(run_once(question))
