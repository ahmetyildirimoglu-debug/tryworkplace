Faz 0 — Altyapı & Mimari

Tech stack: Python/FastAPI, PostgreSQL, Redis, Celery
LLM provider seçimi (Anthropic / OpenAI / hybrid)
Monorepo: agent/ api/ dashboard/ worker/
DB şeması: conversations, messages, leads, channels, tenants
Deployment: Docker + CI/CD pipeline

Faz 1 — Core Agent Engine [v0.1]

LLM wrapper: prompt yönetimi, context window, system prompt şablonları
Conversation memory: short-term (Redis) + long-term (DB)
Intent classifier: satın alma sinyali, itiraz, randevu talebi, genel soru
Web scraper: URL → ürün/fiyat/argüman otomatik öğrenim (BeautifulSoup / Playwright)
Handoff logic: insan devralma trigger koşulları

Faz 2 — Kanal Entegrasyonları [v0.2]

WhatsApp Business API (Meta Cloud API) webhook + gönderim
Instagram DM (Meta Graph API) webhook + gönderim
Web chat widget (embeddable JS snippet + WebSocket)
Multimodal input: ses (Whisper), görsel (vision model), PDF parse
Unified inbox: tüm kanallar tek event bus üzerinden

Faz 3 — Satış Fonksiyonları [v0.3]

Lead qualification pipeline: skor + etiket sistemi
Appointment booking: takvim entegrasyonu (Google Calendar / Calendly API), chat içi akış
Follow-up scheduler: yanıtsız lead'e otomatik hatırlatma kuyrukları
Objection handler: eğitilebilir itiraz-cevap vektör DB (pgvector)

Faz 4 — Dashboard & Yönetim Paneli [v0.4]

Tenant yönetimi: işletme kaydı, kanal bağlama, API key
Conversation view: gerçek zamanlı inbox, human takeover butonu
Analytics: conversion rate, yanıt süresi, kanal bazlı performans
Prompt/persona editörü: no-code agent kişiselleştirme

Faz 5 — White-Label Altyapısı [v0.5]

Multi-tenant mimari: subdomain routing, logo/renk özelleştirme
Reseller paneli: müşteri ekleme, kullanım takibi, fatura
Maliyet izolasyonu: per-tenant LLM token sayacı + limit
Özel domain desteği (CNAME)

Faz 6 — Üretim Olgunluğu [v1.0]

Rate limiting, abuse detection
Veri şifreleme at-rest + in-transit
KVKK/GDPR uyum: veri silme, export
Yük testleri + autoscaling kuralları
Observability: logging (Loki), metrics (Prometheus), tracing (Jaeger)


Changelog formatı önerisi:
CHANGELOG.md

## [Unreleased]
## [0.5.0] - White-Label
## [0.4.0] - Dashboard
## [0.3.0] - Sales Features
## [0.2.0] - Channel Integrations
## [0.1.0] - Core Agent
## [0.0.1] - Project Init
Hangi fazdan başlamak istiyorsun? Teknik spec veya DB şeması hazırlayabilirim.süreç ne kadar olur sabah akşam tüm eforumuzu buna versek10:04Dürüst bir tahmin:
Yalnız çalışıyorsan (1 full-stack dev): ~8-12 ay
2 kişi (backend + frontend): ~4-6 ay

Ama asıl mesele şu:
En uzun süren şeyler kod değil:

Meta'nın WhatsApp Business API onayı → 2-8 hafta bekleme, reddedilme riski var
Instagram DM API → aynı süreç, ayrı başvuru
İlk müşteri onboarding'i → agent'ı her işletmeye göre ayarlamak beklenenden 3x uzun sürüyor
Multimodal (ses/görsel) → çalıştırmak kolay, production kalitesine getirmek zor

Gerçekçi MVP süresi (sadece WhatsApp + web chat + temel agent):
Sabah akşam, 2 kişi → 6-8 hafta
Bu MVP ile ilk müşteriyi alabilirsin. Geri kalanı para gelince geliştirilir.

Tavsiyem:
Faz 2'deki Instagram'ı ve Faz 3'teki multimodal'ı sonraya bırak. Meta API onay sürecini bugün başlat, kod yazmadan önce. O süreç işlerken core agent'ı geliştir.
Hangi platformda geliştirmeyi düşünüyorsunuz, tamamen custom mu yoksa n8n/Langchain gibi bir framework üzerine mi?
