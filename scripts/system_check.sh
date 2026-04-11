#!/bin/bash
echo "=== SENTINEL System Check ==="
echo "Tarih: $(date)"
echo "Hostname: $(hostname)"
echo "IP: $(ip addr show enp0s3 | grep 'inet ' | awk '{print $2}')"
echo "CPU: $(top -bn1 | grep 'Cpu' | awk '{print $2}')% kullanim"
echo "RAM: $(free -m | awk 'NR==2{print $3}')MB / $(free -m | awk 'NR==2{print $2}')MB"
echo "Disk: $(df -h / | awk 'NR==2{print $5}') dolu"
echo "==========================="
