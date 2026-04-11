#!/usr/bin/env python3
import subprocess
import datetime
def run(cmd):
    return subprocess.check_output(cmd, shell=True).decode().strip()
print("=== SENTINEL Python Monitor ===")
print(f"Zaman: {datetime.datetime.now()}")
print(f"Hostname: {run('hostname')}")
print(f"Uptime: {run('uptime -p')}")
disk_cmd = "df -h / | tail -1 | awk '{print $5}'"
print(f"Disk: {run(disk_cmd)}")
print("===============================")
