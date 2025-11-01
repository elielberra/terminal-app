import sys
from app.rag.chain import run_once

if __name__ == "__main__":
    question = " ".join(sys.argv[1:]) or "What is Eliel latest work experience?"
    print(run_once(question))
