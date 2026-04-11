# Context M1 — Git + Bash Scripting

## Durum: devam ediyor

## Tamamlananlar
- [x] Bash script yazımı: system_check.sh
- [x] chmod +x ile çalıştırılabilir yapma
- [x] Cron job: her 5 dakikada otomatik çalışma
- [x] Log dosyasına yönlendirme: >> ve 2>&1

## Öğrenilen Kavramlar
- #!/bin/bash shebang satırı
- $(komut) ile komut çıktısını değişkene alma
- awk ile metin işleme
- crontab -e ile zamanlı görev

## Sonraki
- Git kurulumu ve repo yönetimi
- Python ile otomasyon scriptleri



"M1 başlıyor. Konumuz: Git + Bash Scripting
Önce VM'e tekrar gir:
vagrant sshevet13:35İlk Bash scriptini yazıyoruz. Bu script SENTINEL'in temel otomasyon aracı olacak:
bashnano ~/sentinel/scripts/system_check.sh
Açılan editöre şunu yaz:
bash#!/bin/bash
echo "=== SENTINEL System Check ==="
echo "Tarih: $(date)"
echo "Hostname: $(hostname)"
echo "IP: $(ip addr show enp0s3 | grep 'inet ' | awk '{print $2}')"
echo "CPU: $(top -bn1 | grep 'Cpu' | awk '{print $2}')% kullanim"
echo "RAM: $(free -m | awk 'NR==2{print $3}')MB / $(free -m | awk 'NR==2{print $2}')MB"
echo "Disk: $(df -h / | awk 'NR==2{print $5}') dolu"
echo "==========================="
Kaydet: Ctrl+X → Y → Enter

evt13:37Şimdi çalıştırılabilir yap ve çalıştır:
bashchmod +x ~/sentinel/scripts/system_check.sh
~/sentinel/scripts/system_check.shvagrant@ubuntu-jammy:~$ chmod +x ~/sentinel/scripts/system_check.sh
~/sentinel/scripts/system_check.sh
=== SENTINEL System Check ===
Tarih: Sat Apr 11 10:37:19 UTC 2026
Hostname: ubuntu-jammy
IP: 10.0.2.15/24
CPU: 0.0% kullanim
RAM: 180MB / 957MB
Disk: 5% dolu
===========================13:37İlk Bash scriptin çalıştı! SENTINEL'in sistem kontrol aracı hazır.
Şimdi bunu otomatik çalıştıralım — cron job:
bashcrontab -e
Editör seçimi sorarsa 1 yaz (nano). Açılan dosyanın en altına ekle:
*/5 * * * * /home/vagrant/sentinel/scripts/system_check.sh >> /home/vagrant/sentinel/logs/system.log 2>&1
Kaydet: Ctrl+X → Y → Enter
Sonra kontrol et:
bashcrontab -lvagrant@ubuntu-jammy:~$ crontab -l
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
*/5 * * * * /home/vagrant/sentinel/scripts/system_check.sh >> /home/vagrant/sentinel/logs/system.log 2>&1
vagrant@ubuntu-jammy:~$Show more13:40Cron job aktif. Her 5 dakikada bir sistem kontrolü otomatik çalışacak.
5 dakika bekle, sonra log'u kontrol et:
bashcat ~/sentinel/logs/system.log"
