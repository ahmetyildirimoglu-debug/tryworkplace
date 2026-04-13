#!/usr/bin/env python3
import subprocess

def analyze_log(log_text):
    prompt = f"You are a DevOps expert. Analyze this log and say: 1) Is there an error? 2) What should be done? 3) Is system healthy?\n\nLog:\n{log_text}"
    result = subprocess.run(
        ["ollama", "run", "tinyllama", prompt],
        capture_output=True, text=True
    )
    return result.stdout

if __name__ == "__main__":
    test_log = """
    ERROR: Container sentinel-app crashed with exit code 1
    Memory usage: 95%
    CPU: 10%
    Disk: 5%
    """
    print(analyze_log(test_log))
