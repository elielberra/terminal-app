# -*- coding: utf-8 -*-
# Minimal NumPy vector store: build + search
import os, sys, json, numpy as np
from sentence_transformers import SentenceTransformer
from pathlib import Path

# Base directory → project root (two levels up from this file)
BASE_DIR = Path(__file__).resolve().parents[1]

INPUT_FILE = BASE_DIR / "data" / "eliel.txt"
STORE_DIR = BASE_DIR / "store"
EMB_FILE  = STORE_DIR / "store_embeddings.npy"
TXT_FILE  = STORE_DIR / "store_chunks.json"

# INPUT_FILE = "eliel.txt"
MODEL_NAME = "sentence-transformers/all-mpnet-base-v2"  # small, 384-d
# EMB_FILE = "store_embeddings.npy"
# TXT_FILE = "store_chunks.json"

# ---------- step 1: read ----------
def read_text(path: str) -> str:
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

# ---------- step 2: chunk (simple, robust) ----------
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


# ---------- step 3: embed + normalize ----------
def embed_chunks(chunks, model_name=MODEL_NAME):
    model = SentenceTransformer(model_name)
    X = model.encode(chunks, normalize_embeddings=True)  # already unit-length
    return model, X.astype("float32")

# ---------- step 4: persist ----------
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
    # 1️⃣ Encode the query
    q = model.encode([query], normalize_embeddings=True)[0].astype("float32")

    # 2️⃣ Compute cosine similarity (dot product)
    scores = X @ q

    # 3️⃣ Sort and select top-k
    idx = np.argsort(-scores)[:k]
    print(f"results:\n{[(float(scores[i]), chunks[i]) for i in idx]}\n")

    return [(float(scores[i]), chunks[i]) for i in idx]

def query(q: str, k: int = 5):
    # 1️⃣ Load stored data
    chunks, X = load_store()

    # 2️⃣ Load the model
    model = SentenceTransformer(MODEL_NAME)

    # 3️⃣ Perform the search
    results = search(q, model, X, chunks, k=k)

    # ✅ 4️⃣ Return results instead of printing
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

