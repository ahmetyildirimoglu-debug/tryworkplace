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

## AWS Tamamlananlar
- [x] AWS hesabı açıldı
- [x] Billing alarm kuruldu
- [x] IAM user: sentinel-admin
- [x] Access Key oluşturuldu
- [x] AWS CLI kurulumu ve configure
- [x] Region: us-east-1
- [x] Security Group: sg-06f2736a0d4199042
- [x] Key Pair: sentinel-key

## Yarın
- S3 bucket
- EC2 instance başlatma
- SENTINEL cloud deploy
