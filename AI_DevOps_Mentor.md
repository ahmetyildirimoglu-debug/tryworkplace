PROJE ADI: AI DevOps Mentor

M0 — Ortam Kurulumu

AWS hesabı aç, IAM user, billing alarm
Lokal: VS Code, Git, Java 11, Maven, Docker Desktop
AWS CLI kurulum + configure
GitHub repo aç: ai-devops-mentor
Çıktı: m0_completed.md

M1 — Jenkins + GitHub + Maven

EC2'da Jenkins kurulumu (t2.micro)
GitHub webhook entegrasyonu
Maven build job oluşturma
Sample Java uygulaması: basit REST API
Çıktı: her commit'te otomatik build çalışıyor + m1_completed.md

M2 — Docker

EC2'da Docker kurulumu
Java uygulaması için Dockerfile yazımı
Jenkins'ten Docker build tetikleme
DockerHub'a otomatik push
Çıktı: her commit'te image DockerHub'a gidiyor + m2_completed.md

M3 — Ansible

Ansible server kurulumu (ayrı EC2)
Jenkins → Ansible entegrasyonu
Playbook: Docker image çek + container ayağa kaldır
Inventory yönetimi
Çıktı: Ansible ile otomatik deploy + m3_completed.md

M4 — Kubernetes + EKS

eksctl ile EKS cluster kurulumu
kubectl kurulum + konfigürasyon
Manifest dosyaları: Deployment + Service
Rolling update testi
Çıktı: uygulama K8s'te çalışıyor + m4_completed.md

M5 — Full CI/CD Pipeline

Jenkins pipeline script (Jenkinsfile)
Git → Maven → Docker → Ansible → K8s tam akış
Pipeline görselleştirme
Hata senaryoları testi
Çıktı: uçtan uca çalışan pipeline + m5_completed.md

M6 — Analyzer Agent

LangChain + LangGraph kurulumu
Jenkins log okuma: API entegrasyonu
Hata tespit ajanı: log → analiz → rapor
LangSmith bağlantısı
Çıktı: hata analiz eden çalışan ajan + m6_completed.md

M7 — Guide + Code Agent

Guide Agent: adım adım yönlendirme mantığı
Code Agent: Dockerfile, playbook, manifest üretimi
Araçlar: file writer, command suggester
Agent araçları test senaryoları
Çıktı: kod üreten ve yönlendiren ajan + m7_completed.md

M8 — Supervisor + LangGraph Orkestrasyon

Supervisor agent mimarisi
LangGraph state machine kurulumu
Analyzer → Guide → Code ajan akışı
Hata durumu yönetimi
Çıktı: tam multi-agent sistem + m8_completed.md

M9 — Production Deploy

FastAPI ile agent API'si
Modal.com deploy
Basit web arayüzü: kullanıcı log yapıştırır, sistem analiz eder
LangSmith dashboard: maliyet + performans izleme
Çıktı: canlı çalışan sistem URL'i + m9_completed.md


Toplam: 9 modül, her biri bağımsız çıktılı, bir sonrakine input olan yapı.
AWS maliyeti: ~20-40$ toplam (kursluk kullanım, her EC2'yu modül bitince durdur)

Planı onaylıyor musun? Onaylarsan şimdi M0_completed.md şablonunu oluşturuyorum ve AWS hesabı açmakla başlıyoruz.ben sonucunda neler öğrenmiş olacağım bu eğitimi aldığımı ispatlayacak bir sinavdan geçebilecek bir seviyeye gelebilir miyim? uzaktan bir firmaya destek verebilir miyim? bana gerçekçi ve realist olarak cevap ver!11:08Gerçekçi cevap:

Ne öğrenmiş olacaksın:
DevOps tarafında Jenkins, Docker, Ansible, Kubernetes, EKS'i gerçek bir projede ellerin kirletmiş olacak. Kavramsal değil, çalışan bir sistem kurmuş olacaksın.
AI tarafında multi-agent mimari, LangGraph, LangSmith, production deploy bileceksin.

Sınav geçer misin?
AWS Certified DevOps Engineer veya CKA (Kubernetes) gibi sertifikalar için hayır, yetmez. Bu sertifikalar için ek 2-3 ay sınava özel çalışma gerekir. Ama bu proje o sınavlara giden yolun en sağlam temelidir.

Uzaktan firma'ya destek verebilir misin?
Şu pozisyonlar için evet:

Junior DevOps Engineer
AI/Automation Developer
MLOps Junior

Şu pozisyonlar için henüz hayır:

Senior DevOps
Platform Engineer
Cloud Architect


En gerçekçi senaryo:
Bu projeyi bitirdiğinde elinde çalışan bir sistem olacak. GitHub'da kod, canlı URL, dokümantasyon. Bu portfolyo sana "Junior" seviye uzaktan iş getirir. Ücret aralığı: 1500-3000$/ay uzaktan.
Ama şunu söyleyeyim: 6 aylık ajan geliştirme geçmişin + bu proje = piyasada nadir bulunan bir profil. Çünkü DevOps bilen çok, AI bilen çok, ikisini birleştiren az.

Tek şart: Projeyi gerçekten bitirmek. Yarım kalan portfolyo değersiz.
