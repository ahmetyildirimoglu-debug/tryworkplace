# 🛡️ SENTINEL
**AI-Powered DevSecOps Automation Platform**

## Ne Yapıyor?
Geliştirici kodu push eder, geri kalan her şeyi SENTINEL halleder.
- Jenkins ile otomatik CI/CD pipeline
- Docker ile containerization
- Kubernetes ile orkestrasyon
- Prometheus + Grafana ile monitoring
- AI ajanlar ile log analizi ve otomatik çözüm üretimi

## Teknoloji Stack
| Katman | Teknoloji |
|--------|-----------|
| CI/CD | Jenkins, Ansible |
| Container | Docker, Kubernetes |
| Monitoring | Prometheus, Grafana |
| AI | LangGraph, Ollama, tinyllama |
| API | FastAPI |
| Cloud | AWS |

## Kurulum
```bash
git clone https://github.com/ahmetyildirimoglu-debug/tryworkplace
cd sentinel
vagrant up
vagrant ssh
```

## API Kullanımı
```bash
# Sağlık kontrolü
curl http://localhost:8000/health

# Log analizi
curl -X POST http://localhost:8000/analyze \
  -H "Content-Type: application/json" \
  -d '{"log": "ERROR: Container crashed"}'
```

## Modüller
- M0: Linux + Vagrant kurulumu
- M1: Git + Bash + Python
- M3: Jenkins CI/CD
- M4: Ansible otomasyon
- M5: Docker + Kubernetes
- M8: Prometheus + Grafana
- M9: LangGraph orkestrasyon
- M10-M11: AI Ajanlar
- M12: FastAPI
