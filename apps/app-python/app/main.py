from fastapi import FastAPI

app = FastAPI(title="app-python", version="0.1.0")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/greet/{name}")
def greet(name: str) -> dict[str, str]:
    return {"message": f"hello, {name}"}
