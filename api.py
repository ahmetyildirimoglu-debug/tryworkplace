#!/usr/bin/env python3
from fastapi import FastAPI
from pydantic import BaseModel
from agents.sentinel_graph import app as sentinel_app

api = FastAPI(title="SENTINEL API")

class LogRequest(BaseModel):
    log: str

@api.post("/analyze")
def analyze(request: LogRequest):
    result = sentinel_app.invoke({
        "log": request.log,
        "analysis": "",
        "guidance": "",
        "code": ""
    })
    return {
        "analysis": result["analysis"],
        "guidance": result["guidance"],
        "code": result["code"]
    }

@api.get("/health")
def health():
    return {"status": "ok", "service": "SENTINEL"}