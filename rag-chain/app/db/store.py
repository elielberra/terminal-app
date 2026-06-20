import os
import sqlite3

DB_PATH = os.getenv("SQLITE_DB_PATH", "/rag-chain/store/conversations.db")

def _conn():
    return sqlite3.connect(DB_PATH)

def init_db():
    with _conn() as con:
        con.execute("""
            CREATE TABLE IF NOT EXISTS conversations (
                session_id TEXT      PRIMARY KEY,
                content    TEXT      NOT NULL,
                ip         TEXT,
                location   TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)

def save_conversation(session_id: str, content: str, ip: str = None, location: str = None):
    with _conn() as con:
        con.execute(
            "INSERT INTO conversations (session_id, content, ip, location) VALUES (?, ?, ?, ?)",
            (session_id, content, ip, location),
        )
