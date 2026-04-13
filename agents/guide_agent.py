#!/usr/bin/env python3
import subprocess

def guide(issue):
    prompt = f"""You are a DevOps engineer. Give step by step solution for this issue:

Issue: {issue}

Provide:
1. Root cause
2. Step by step fix
3. Prevention tips"""
    
    result = subprocess.run(
        ["ollama", "run", "tinyllama", prompt],
        capture_output=True, text=True
    )
    return result.stdout

if __name__ == "__main__":
    issue = "Container keeps crashing with exit code 137, memory usage at 95%"
    print(guide(issue))