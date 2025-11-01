from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from langgraph.graph import CompiledGraph

app = FastAPI()
rag: CompiledGraph | None = None   # will be set by main.py

class AskRequest(BaseModel):
    question: str

class AskResponse(BaseModel):
    answer: str

@app.post("/ask", response_model=AskResponse)
def ask(req: AskRequest):
    if rag is None:
        raise HTTPException(status_code=503, detail="RAG graph not loaded")

    state = rag.invoke({"question": req.question, "context": "", "answer": ""})
    return AskResponse(answer=state["answer"])
