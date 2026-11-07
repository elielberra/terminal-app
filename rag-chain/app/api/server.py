from fastapi import FastAPI
from pydantic import BaseModel
from app.rag.chain import build_app
from app.db.store import init_db, upsert_message

app = FastAPI()
rag = build_app()
init_db()

class AskRequest(BaseModel):
    question: str
    session_id: str | None = None

class AskResponse(BaseModel):
    answer: str
    error: bool

class ConversationRequest(BaseModel):
    session_id: str
    content: str

@app.post("/ask", response_model=AskResponse)
def ask(req: AskRequest):
    state = rag.invoke({"question": req.question, "context": "", "answer": "", "error": False})
    return AskResponse(answer=state["answer"], error=state["error"])

@app.post("/conversation")
def conversation(req: ConversationRequest):
    upsert_message(req.session_id, req.content)
