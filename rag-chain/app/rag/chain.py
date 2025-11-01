# app/rag/chain.py
from __future__ import annotations
from typing import TypedDict
import io
import os
import contextlib

# LangGraph
from langgraph.graph import StateGraph, END

# Vector store (your existing module)
# We will call its `query()` and capture the printed context.
from vector_store import vector_store as vs

# Google AI Studio (Gemini 2.0 Flash Lite)
import google.generativeai as genai


# ---------- RAG State ----------
class RAGState(TypedDict):
    question: str
    context: str
    answer: str


# ---------- Nodes ----------
def retrieve(state: RAGState) -> RAGState:
    """
    Calls your vector store's `query()` and uses the returned chunks
    as retrieval context.
    """
    # Perform similarity search
    results = vs.query(state["question"], k=5)

    # Join the text chunks into a single context string
    context_text = "\n\n".join([t for _, t in results])

    return {
        "question": state["question"],
        "context": context_text,
        "answer": state.get("answer", ""),
    }


def generate(state: RAGState) -> RAGState:
    """
    Sends a minimal prompt with the captured context to Gemini 2.0 Flash Lite.
    Requires GOOGLE_API_KEY in environment.
    """
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise RuntimeError("GOOGLE_API_KEY is not set in environment.")
    genai.configure(api_key=api_key)

    model = genai.GenerativeModel("gemini-2.0-flash-lite")

    prompt = (
        "You are a concise assistant that answers questions about a person named Eliel Berra."
        "Use ONLY the provided context to answer the question. The provided context will be about Eliel Berra."
        "If the context is insufficient, say \"I don't know\".\n\n"
        f"Context:\n{state['context']}\n\n"
        f"Question:\n{state['question']}\n\n"
        "Answer:"
    )

    resp = model.generate_content(prompt)
    answer_text = getattr(resp, "text", "").strip() if resp else ""

    return {
        "question": state["question"],
        "context": state["context"],
        "answer": answer_text,
    }


# ---------- Graph Builder ----------
def build_app():
    graph = StateGraph(RAGState)
    graph.add_node("retrieve", retrieve)
    graph.add_node("generate", generate)
    graph.set_entry_point("retrieve")
    graph.add_edge("retrieve", "generate")
    graph.add_edge("generate", END)
    return graph.compile()


# ---------- Convenience runner ----------
# Example usage:
#   from app.rag.chain import run_once
#   print(run_once("Who is Eliel?"))
def run_once(question: str) -> str:
    app = build_app()
    final_state = app.invoke({"question": question, "context": "", "answer": ""})
    return final_state["answer"]
