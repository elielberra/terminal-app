import os
from google import genai
from google.genai import types

_client = None

def get_client() -> genai.Client:
    global _client
    if _client is None:
        api_key = os.getenv("GOOGLE_API_KEY")
        if not api_key:
            raise RuntimeError("GOOGLE_API_KEY is not set in environment.")
        _client = genai.Client(
            api_key=api_key,
            http_options=types.HttpOptions(api_version="v1"),
        )
    return _client
