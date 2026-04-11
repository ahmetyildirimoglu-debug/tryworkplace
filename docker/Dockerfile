FROM ubuntu:22.04
RUN apt-get update && apt-get install -y python3
COPY scripts/sentinel_monitor.py /app/monitor.py
CMD ["python3", "/app/monitor.py"]
