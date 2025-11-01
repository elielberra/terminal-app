print("Loading vector_store.py file")
import os, sys, json, numpy as np
from sentence_transformers import SentenceTransformer
from pathlib import Path
from time import time

BASE_DIR = Path(__file__).resolve().parents[2]
INPUT_FILE = BASE_DIR / "data" / "eliel.txt"
STORE_DIR = BASE_DIR / "store"
EMB_FILE  = STORE_DIR / "store_embeddings.npy"
TXT_FILE  = STORE_DIR / "store_chunks.json"
print("Loading model")
MODEL_NAME = "sentence-transformers/all-mpnet-base-v2"
MODEL = SentenceTransformer(MODEL_NAME)

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
    current_section = None   # e.g., "Work Experience"
    current_sub = None       # e.g., "AI Engineer – Lovelytics"
    buf = []

    def flush():
        if current_sub and buf:
            body = "\n".join(buf).strip()
            if body:
                # Include headers so the chunk has context
                header = f"# {current_section}\n## {current_sub}"
                chunks.append(f"{header}\n\n{body}")
        buf.clear()

    for raw in lines:
        line = raw.rstrip()

        # Top-level section (e.g., "# Work Experience")
        if line.startswith("# ") and not line.startswith("## "):
            # new section: flush any open subsection
            flush()
            current_section = line[2:].strip()
            current_sub = None
            continue

        # Subsection (e.g., "## AI Engineer – Lovelytics")
        if line.startswith("## "):
            # starting a new subsection: flush previous one
            flush()
            current_sub = line[3:].strip()
            continue

        # Accumulate body lines only if we are inside a subsection
        if current_sub:
            buf.append(line)

    # Flush last subsection
    flush()

    # Fallback if no markdown structure was detected
    if not chunks:
        paras = [p.strip() for p in text.split("\n\n") if p.strip()]
        return paras

    return chunks


def embed_chunks(chunks):
    X = MODEL.encode(chunks, normalize_embeddings=True)
    return MODEL, X.astype("float32")

def save_store(chunks, X):
    np.save(EMB_FILE, X)
    with open(TXT_FILE, "w", encoding="utf-8") as f:
        json.dump(chunks, f, ensure_ascii=False)

def load_store():
    X = np.load(EMB_FILE)
    chunks = json.load(open(TXT_FILE, encoding="utf-8"))
    return chunks, X

# ---------- CLI ----------
def build():
    if not os.path.exists(INPUT_FILE):
        print(f"Missing {INPUT_FILE}")
        sys.exit(1)
    text = read_text(str(INPUT_FILE))
    chunks = make_chunks(text)
    _, X = embed_chunks(chunks)
    save_store(chunks, X)
    print(f"Built store: {len(chunks)} chunks")

def search(query: str, model, X: np.ndarray, chunks, k: int = 5):
    q = model.encode([query], normalize_embeddings=True)[0].astype("float32")
    scores = X @ q
    idx = np.argsort(-scores)[:k]
    return [(float(scores[i]), chunks[i]) for i in idx]

def query(q: str, k: int = 5):
    start_query = time()
    chunks, X = load_store()
    results = search(q, MODEL, X, chunks, k=k)
    end_query = time()
    print(f"Total query:   {end_query - start_query:.4f} s")
    return [(float(s), t) for s, t in results]


if __name__ == "__main__":
    # Usage:
    #   python vector_store.py build
    #   python vector_store.py query "your question" 5
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

