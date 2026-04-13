
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y python3
COPY scripts/sentinel_monitor.py /app/monitor.py
CMD ["sh", "-c", "while true; do python3 /app/monitor.py; sleep 30; done"]
