#!/usr/bin/env python3
from typing import TypedDict
from langgraph.graph import StateGraph, END
import subprocess

class SentinelState(TypedDict):
    log: str
    analysis: str
    guidance: str
    code: str

def run_ollama(prompt):
    result = subprocess.run(
        ["ollama", "run", "tinyllama", prompt],
        capture_output=True, text=True
    )
    return result.stdout

def analyzer_node(state: SentinelState):
    print("[ANALYZER] çalışıyor...")
    analysis = run_ollama(f"Analyze this log briefly: {state['log']}")
    return {"analysis": analysis}

def guide_node(state: SentinelState):
    print("[GUIDE] çalışıyor...")
    guidance = run_ollama(f"Give 3 quick fixes for: {state['analysis']}")
    return {"guidance": guidance}

def code_node(state: SentinelState):
    print("[CODE] çalışıyor...")
    code = run_ollama(f"Write a bash command to fix: {state['analysis']}")
    return {"code": code}

workflow = StateGraph(SentinelState)
workflow.add_node("analyzer", analyzer_node)
workflow.add_node("guide", guide_node)
workflow.add_node("code", code_node)

workflow.set_entry_point("analyzer")
workflow.add_edge("analyzer", "guide")
workflow.add_edge("guide", "code")
workflow.add_edge("code", END)

app = workflow.compile()

if __name__ == "__main__":
    result = app.invoke({
        "log": "ERROR: Container crashed, memory 95%, exit code 137",
        "analysis": "",
        "guidance": "",
        "code": ""
    })
    print("\n=== SENTINEL GRAPH SONUCU ===")
    print("ANALYSIS:", result["analysis"][:200])
    print("GUIDANCE:", result["guidance"][:200])
    print("CODE:", result["code"][:200])