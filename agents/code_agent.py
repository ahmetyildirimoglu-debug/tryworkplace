#!/usr/bin/env python3
import subprocess

def generate_code(task):
    prompt = f"""You are a DevOps engineer. Generate only the code/config for this task, no explanation:

Task: {task}"""
    
    result = subprocess.run(
        ["ollama", "run", "tinyllama", prompt],
        capture_output=True, text=True
    )
    return result.stdout

if __name__ == "__main__":
    task = "Write a Dockerfile for a Python Flask app with health check"
    print(generate_code(task))