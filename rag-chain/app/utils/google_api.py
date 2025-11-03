import os
import google.generativeai as genai

def configure_google_api():
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise RuntimeError("GOOGLE_API_KEY is not set in environment.")
    genai.configure(api_key=api_key)
