import os, sys, json, numpy as np
from pathlib import Path
import google.generativeai as genai
from app.utils.google_api import configure_google_api

configure_google_api()
EMBED_MODEL = "text-embedding-004"

BASE_DIR = Path(__file__).resolve().parents[2]
INPUT_FILE = BASE_DIR / "data" / "eliel.txt"
STORE_DIR = BASE_DIR / "store"
EMB_FILE  = STORE_DIR / "store_embeddings.npy"
TXT_FILE  = STORE_DIR / "store_chunks.json"

def read_text(path: str) -> str:
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

def make_chunks(text: str):
    """
    Chunk a Markdown CV into one chunk per '##' subsection, grouped under its '#' section.
    If no markdown headings are found, falls back to paragraph-based chunks.
    """
    lines = text.splitlines()
    chunks = []
    current_section = None
    current_sub = None
    buf = []

    def flush():
        if current_sub and buf:
            body = "\n".join(buf).strip()
            if body:
                header = f"# {current_section}\n## {current_sub}"
                chunks.append(f"{header}\n\n{body}")
        buf.clear()

    for raw in lines:
        line = raw.rstrip()
        if line.startswith("# ") and not line.startswith("## "):
            flush()
            current_section = line[2:].strip()
            current_sub = None
            continue
        if line.startswith("## "):
            flush()
            current_sub = line[3:].strip()
            continue
        if current_sub:
            buf.append(line)

    flush()

    if not chunks:
        paras = [p.strip() for p in text.split("\n\n") if p.strip()]
        return paras

    return chunks

def embed_texts(texts):
    vecs = []
    for t in texts:
        r = genai.embed_content(model=EMBED_MODEL, content=t)
        v = np.array(r["embedding"], dtype="float32")
        n = np.linalg.norm(v)
        vecs.append(v / n if n else v)
    return np.vstack(vecs)

def embed_chunks(chunks):
    X = embed_texts(chunks)
    return X

def save_store(chunks, X):
    np.save(EMB_FILE, X)
    with open(TXT_FILE, "w", encoding="utf-8") as f:
        json.dump(chunks, f, ensure_ascii=False)

def load_store():
    X = np.load(EMB_FILE)
    chunks = json.load(open(TXT_FILE, encoding="utf-8"))
    return chunks, X

def build():
    print("Building vector store and chunks")
    if not os.path.exists(INPUT_FILE):
        print(f"Missing {INPUT_FILE}")
        sys.exit(1)
    text = read_text(str(INPUT_FILE))
    chunks = make_chunks(text)
    X = embed_chunks(chunks)
    save_store(chunks, X)
    print(f"Built store: {len(chunks)} chunks")

def search(query: str, X: np.ndarray, chunks, k: int = 5):
    q = embed_texts([query])[0]
    scores = X @ q
    idx = np.argsort(-scores)[:k]
    return [(float(scores[i]), chunks[i]) for i in idx]

def query(q: str, k: int = 5):
    chunks, X = load_store()
    results = search(q, X, chunks, k=k)
    return [(float(s), t) for s, t in results]

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python vector_store.py build | query 'text' [k]")
        sys.exit(1)
    cmd = sys.argv[1]
    if cmd == "build":
        build()
    elif cmd == "query":
        if len(sys.argv) < 3:
            print("Provide a query string.")
            sys.exit(1)
        k = int(sys.argv[3]) if len(sys.argv) > 3 else 5
        query(sys.argv[2], k)
    else:
        print("Unknown command.")
        sys.exit(1)
