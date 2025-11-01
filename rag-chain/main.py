import uvicorn

if __name__ == "__main__":
    print("Starting FastAPI server on http://localhost:5000 ...")
    uvicorn.run("app.api.server:app", host="0.0.0.0", port=5000, reload=False)

