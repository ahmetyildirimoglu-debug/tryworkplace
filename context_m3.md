# Context M3 — Jenkins CI/CD

## Tamamlananlar
- [x] Java 17 kurulumu
- [x] Jenkins 2.541.3 war ile kuruldu
- [x] Port forwarding: 8080
- [x] İlk freestyle job: sentinel-pipeline
- [x] Console output: SUCCESS

## Erişim
- URL: http://localhost:8080
- User: 90091e
- Admin şifre: b559fe84d5ac48a68d2853fa1717a906

## Sonraki
- GitHub webhook entegrasyonu
- Jenkinsfile ile pipeline as code
Ne öğrendik: Jenkinsfile ile pipeline'ı kod olarak yazdık. Bu GitOps'un temelidir — pipeline kodu Git'te yaşar, versiyon kontrolü altında.

## Ansible Tamamlananlar
- [x] Ansible kurulumu
- [x] inventory.ini oluşturuldu
- [x] system_check.yml playbook
- [x] deploy.yml playbook
- [x] Jenkins + Docker + Ansible tam pipeline
