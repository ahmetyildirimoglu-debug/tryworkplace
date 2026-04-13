#!/usr/bin/env python3
from analyzer import analyze_log
from guide_agent import guide
from code_agent import generate_code

def supervisor(log_text):
    print("=" * 50)
    print("SENTINEL AI SUPERVISOR")
    print("=" * 50)
    
    print("\n[1] ANALYZER AGENT çalışıyor...")
    analysis = analyze_log(log_text)
    print(analysis)
    
    print("\n[2] GUIDE AGENT çalışıyor...")
    guidance = guide(log_text)
    print(guidance)
    
    print("\n[3] CODE AGENT çalışıyor...")
    code = generate_code("Fix the issue: " + log_text[:100])
    print(code)
    
    print("\n" + "=" * 50)
    print("SENTINEL analizi tamamlandı.")

if __name__ == "__main__":
    test_log = "ERROR: Container crashed, memory 95%, exit code 137"
    supervisor(test_log)