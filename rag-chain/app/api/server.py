import re

from fastapi import FastAPI
from pydantic import BaseModel, Field, field_validator
from app.rag.chain import build_app
from app.db.store import init_db, upsert_message

app = FastAPI()
rag = build_app()
init_db()

CONTROL_CHARS = re.compile(r"[\x00-\x08\x0b-\x1f\x7f-\x9f]")

class SanitizedModel(BaseModel):
    @field_validator("*", mode="before")
    @classmethod
    def strip_control(cls, value):
        return CONTROL_CHARS.sub("", value) if isinstance(value, str) else value

class AskRequest(SanitizedModel):
    question: str = Field(min_length=1, max_length=500)
    session_id: str | None = Field(default=None, max_length=64)

class AskResponse(BaseModel):
    answer: str
    error: bool

class ConversationRequest(SanitizedModel):
    session_id: str = Field(min_length=1, max_length=64, pattern=r"^[0-9]+$")
    content: str = Field(min_length=1, max_length=10000)

@app.post("/ask", response_model=AskResponse)
def ask(req: AskRequest):
    state = rag.invoke({"question": req.question, "context": "", "answer": "", "error": False})
    return AskResponse(answer=state["answer"], error=state["error"])

@app.post("/conversation")
def conversation(req: ConversationRequest):
    upsert_message(req.session_id, req.content)
