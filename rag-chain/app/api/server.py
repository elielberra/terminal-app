from fastapi import FastAPI
from pydantic import BaseModel
from app.rag.chain import build_app

app = FastAPI()
rag = build_app()

class AskRequest(BaseModel):
    question: str

class AskResponse(BaseModel):
    answer: str

@app.post("/ask", response_model=AskResponse)
def ask(req: AskRequest):
    state = rag.invoke({"question": req.question, "context": "", "answer": ""})
    return AskResponse(answer=state["answer"])
