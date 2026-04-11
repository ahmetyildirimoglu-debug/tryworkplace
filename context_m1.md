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

M1 tamamlandı.
Ne öğrendik:

Bash scripting + cron job

Git: init, commit, branch, merge

Python ile sistem otomasyonu

------------------------------------------------------------------------------------------------------------


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
bashcat ~/sentinel/logs/system.log
Beklerken context_m0.md yerine artık context_m1.md oluştur GitHub'da:
markdown# Context M1 — Git + Bash Scripting

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
5 dakika dolunca log çıktısını paylaş.vagrant@ubuntu-jammy:~$ cat ~/sentinel/logs/system.log
=== SENTINEL System Check ===
Tarih: Sat Apr 11 10:45:01 UTC 2026
Hostname: ubuntu-jammy
IP: 10.0.2.15/24
CPU: 0.0% kullanim
RAM: 180MB / 957MB
Disk: 5% dolu
===========================
=== SENTINEL System Check ===
Tarih: Sat Apr 11 10:50:01 UTC 2026
Hostname: ubuntu-jammy
IP: 10.0.2.15/24
CPU: 0.0% kullanim
RAM: 180MB / 957MB
Disk: 5% dolu
===========================
=== SENTINEL System Check ===
Tarih: Sat Apr 11 10:55:01 UTC 2026
Hostname: ubuntu-jammy
IP: 10.0.2.15/24
CPU: 0.0% kullanim
RAM: 180MB / 957MB
Disk: 5% dolu
===========================
vagrant@ubuntu-jammy:~$Show more13:56Otomatik çalışıyor. 10:45, 10:50, 10:55 — tam 5 dakikada bir kayıt alıyor.
Şimdi Git kuruyoruz:
bashsudo apt update && sudo apt install -y git
git --versionvagrant@ubuntu-jammy:~$ sudo apt update && sudo apt install -y git
git --version
Hit:1 http://archive.ubuntu.com/ubuntu jammy InRelease
Get:2 http://archive.ubuntu.com/ubuntu jammy-updates InRelease [128 kB]
Get:3 http://security.ubuntu.com/ubuntu jammy-security InRelease [129 kB]
Get:4 http://pasted14:03Git 2.34.1 hazır, zaten kuruluymuş.
Şimdi Git yapılandırması:
bashgit config --global user.name "Ahmet"
git config --global user.email "senin@email.com"
git config --global init.defaultBranch main
git config --list
Email'i kendi GitHub email'inle değiştir.vagrant@ubuntu-jammy:~$ git config --global user.name "Ahmet"
git config --global user.email "ahmet.yildirimoglu@yapkimsan.com.tr"
git config --global init.defaultBranch main
git config --list
user.name=Ahmet
user.email=ahmet.yildirimoglu@yapkimsan.com.tr
init.defaultbranch=main
vagrant@ubuntu-jammy:~$14:05Git yapılandırıldı. Şimdi ilk repo'yu oluşturalım:
bashcd ~/sentinel
git init
git add .
git statusvagrant@ubuntu-jammy:~$ cd ~/sentinel
git init
git add .
git status
Initialized empty Git repository in /home/vagrant/sentinel/.git/
On branch main
No commits yet
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   logs/init.log
        new file:   logs/system.log
        new file:   scripts/system_check.sh
vagrant@ubuntu-jammy:~/sentinel$14:05İlk commit'i yapalım:
bashgit commit -m "feat: initial sentinel project structure"
git log --onelinevagrant@ubuntu-jammy:~/sentinel$ git commit -m "feat: initial sentinel project structure"
git log --oneline
[main (root-commit) ca75bee] feat: initial sentinel project structure
 3 files changed, 50 insertions(+)
 create mode 100644 logs/init.log
 create mode 100644 logs/system.log
 create mode 100755 scripts/system_check.sh
ca75bee (HEAD -> main) feat: initial sentinel project structure
vagrant@ubuntu-jammy:~/sentinel$14:06İlk commit tamam. ca75bee senin ilk commit hash'in.
Şimdi branch kavramını öğreniyoruz — DevOps'ta her özellik ayrı branch'te geliştirilir:
bashgit checkout -b feature/monitoring
git branchvagrant@ubuntu-jammy:~/sentinel$ git checkout -b feature/monitoring
git branch
Switched to a new branch 'feature/monitoring'
* feature/monitoring
  main
vagrant@ubuntu-jammy:~/sentinel$14:06feature/monitoring branch'indesin. Şimdi bu branch'e yeni bir script ekle:
bashnano ~/sentinel/scripts/port_check.sh
İçine yaz:
bash#!/bin/bash
echo "=== Port Check ==="
ss -tlnp | grep LISTEN
echo "=================="
Kaydet: Ctrl+X → Y → Enter
bashchmod +x ~/sentinel/scripts/port_check.sh
git add .
git commit -m "feat: add port check script"
git log --onelinevagrant@ubuntu-jammy:~/sentinel$ nano ~/sentinel/scripts/port_check.sh
vagrant@ubuntu-jammy:~/sentinel$ chmod +x ~/sentinel/scripts/port_check.sh
git add .
git commit -m "feat: add port check script"
git log --oneline
[feature/monitoring 4a26530] feat: add port check script
 1 file changed, 4 insertions(+)
 create mode 100755 scripts/port_check.sh
4a26530 (HEAD -> feature/monitoring) feat: add port check script
ca75bee (main) feat: initial sentinel project structure
vagrant@ubuntu-jammy:~/sentinel$ chmod +x ~/sentinel/scripts/port_check.sh
git add .
git commit -m "feat: add port check script"
git log --oneline
[feature/monitoring 699a44a] feat: add port check script
 1 file changed, 160 insertions(+)
699a44a (HEAD -> feature/monitoring) feat: add port check script
4a26530 feat: add port check script
ca75bee (main) feat: initial sentinel project structure
vagrant@ubuntu-jammy:~/sentinel$Show more15:47İki commit var, sorun değil. Şimdi main'e merge edelim:
bashgit checkout main
git merge feature/monitoring
git log --onelinevagrant@ubuntu-jammy:~/sentinel$ git checkout main
git merge feature/monitoring
git log --oneline
Switched to branch 'main'
Updating ca75bee..699a44a
Fast-forward
 logs/system.log       | 160 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/port_check.sh |   4 +++
 2 files changed, 164 insertions(+)
 create mode 100755 scripts/port_check.sh
699a44a (HEAD -> main, feature/monitoring) feat: add port check script
4a26530 feat: add port check script
ca75bee feat: initial sentinel project structure
vagrant@ubuntu-jammy:~/sentinel$bana kısa kısa bilgiler ver sadece yaptırma !Show more15:48Tamam, kısa özetle:
Ne öğrendik:

git checkout -b → yeni branch aç
git merge → branch'i ana koda birleştir
Fast-forward → çakışma yok, düz birleşme

Neden önemli: SENTINEL'de Jenkins her branch push'unda otomatik build tetikleyecek. Branch olmadan CI/CD olmaz.
Devam edelim mi? Sırada Python scripting var.devam edelim sen kısa kısa bilgi vermeye devam et!15:49Python kuruyoruz:
bashsudo apt install -y python3 python3-pip
python3 --versionRunning kernel seems to be up-to-date.
No services need to be restarted.
No containers need to be restarted.
No user sessions are running outdated binaries.
No VM guests are running outdated hypervisor (qemu) binaries on this host.
Python 3.10.12
vagrant@ubuntu-jammy:~/sentinel$15:50Python 3.10.12 hazır.
İlk Python otomasyon scripti:
bashnano ~/sentinel/scripts/sentinel_monitor.py
İçine yaz:
python#!/usr/bin/env python3
import subprocess
import datetime

def run(cmd):
    return subprocess.check_output(cmd, shell=True).decode().strip()

print("=== SENTINEL Python Monitor ===")
print(f"Zaman: {datetime.datetime.now()}")
print(f"Hostname: {run('hostname')}")
print(f"Uptime: {run('uptime -p')}")
print(f"Disk: {run('df -h / | tail -1 | awk \"{print $5}\"')}")
print("===============================")
Kaydet, çalıştır:
bashpython3 ~/sentinel/scripts/sentinel_monitor.pyctrl + s ile kaydettim ctrl + x ile çıktım doğru mu ?!vagrant@ubuntu-jammy:~/sentinel$ python3 ~/sentinel/scripts/sentinel_monitor.py
  File "/home/vagrant/sentinel/scripts/sentinel_monitor.py", line 12
    print(f"Disk: {run('df -h / | tail -1 | awk \"{print $5}\"')}")
                                                                  ^
SyntaxError: f-string expression part cannot include a backslash
vagrant@ubuntu-jammy:~/sentinel$15:53Ctrl+S nano'da çalışmaz, ama Ctrl+X → Y → Enter doğru yol.
Syntax hatası var, düzeltelim:
bashnano ~/sentinel/scripts/sentinel_monitor.py

satırı şununla değiştir:

pythondisk_cmd = "df -h / | tail -1 | awk '{print $5}'"
print(f"Disk: {run(disk_cmd)}")
Kaydet: Ctrl+X → Y → Enter
bashpython3 ~/sentinel/scripts/sentinel_monitor.py#!/usr/bin/env python3
import subprocess
import datetime
def run(cmd):
    return subprocess.check_output(cmd, shell=True).decode().strip()
print("=== SENTINEL Python Monitor ===")
print(f"Zaman: {datetime.datetime.now()}")
print(f"Hostname: {run('hostname')}")
print(f"Uptime: {run('uptime -p')}")
disk_cmd = "df -h / | tail -1 | awk '{print $5}'"
print(f"Disk: {run(disk_cmd)}")
print("===============================")bu şekilde mi olacak?!Show less15:56Evet, doğru. Çalıştır:
bashpython3 ~/sentinel/scripts/sentinel_monitor.pyvagrant@ubuntu-jammy:~/sentinel$ python3 ~/sentinel/scripts/sentinel_monitor.py
=== SENTINEL Python Monitor ===
Zaman: 2026-04-11 12:58:12.261361
Hostname: ubuntu-jammy
Uptime: up 3 hours, 27 minutes
Disk: 6%
===============================
vagrant@ubuntu-jammy:~/sentinel$içinde değişiklik yapmak biraz zor anlayamadım dışarda kestim yapıştırdım. hepsini silmek zorunda kaldım bana içinde yapacağımız işlemleride yeri geldiğinde anlat şimdi anlatmayabilirsin!15:59Anladım, not aldım. Nano yerine daha sonra VS Code ile düzenlemeyi göstereceğim, çok daha kolay olacak.
Script çalıştı. Git'e commit edelim:
bashgit add .
git commit -m "feat: add python monitor script"vagrant@ubuntu-jammy:~/sentinel$ git add .
git commit -m "feat: add python monitor script"
[main 14334dd] feat: add python monitor script
 2 files changed, 28 insertions(+)
 create mode 100644 scripts/sentinel_monitor.py
vagrant@ubuntu-jammy:~/sentinel$15:59M1 tamamlandı.
Ne öğrendik:

Bash scripting + cron job
Git: init, commit, branch, merge
Python ile sistem otomasyonu

context_m1.md dosyasını GitHub'da güncelle, sonra M2'ye geçiyoruz: Docker.

"
