# Context M12 — FastAPI + SENTINEL API

## Tamamlananlar
- [x] FastAPI kurulumu
- [x] /health endpoint
- [x] /analyze endpoint: log → 3 ajan → JSON
- [x] Swagger UI: http://localhost:8000/docs
- [x] Port 8000 forwarding aktif

## Test
POST /analyze
{"log": "ERROR: Container crashed, memory 95%, exit code 137"}
→ analysis + guidance + code döndü

## Sonraki
- AWS Free Tier kurulumu
- Production deploy
- DevSecOps güvenlik bloğu
