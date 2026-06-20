from fastapi import FastAPI
from pydantic import BaseModel
from app.rag.chain import build_app
from app.db.store import init_db, save_conversation
from app.utils.geo import get_location

app = FastAPI()
rag = build_app()
init_db()

class AskRequest(BaseModel):
    question: str
    session_id: str | None = None
    user_ip: str | None = None
    location: str | None = None

class AskResponse(BaseModel):
    answer: str
    error: bool

class LocateResponse(BaseModel):
    location: str | None

class ConversationRequest(BaseModel):
    session_id: str
    content: str
    user_ip: str | None = None
    location: str | None = None

@app.get("/locate", response_model=LocateResponse)
def locate(ip: str = ""):
    return LocateResponse(location=get_location(ip))

@app.post("/ask", response_model=AskResponse)
def ask(req: AskRequest):
    state = rag.invoke({"question": req.question, "context": "", "answer": "", "error": False})
    return AskResponse(answer=state["answer"], error=state["error"])

@app.post("/conversation")
def conversation(req: ConversationRequest):
    save_conversation(req.session_id, req.content, req.user_ip, req.location)
