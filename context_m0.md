# Context M0 — Ortam Kurulumu

- AWS hesabı aç

## Tamamlananlar
- [x] GitHub repo açıldı
- [x] VS Code kurulu
- [x] Git 2.53.0 kurulu
- [x] Docker 29.3.1 kurulu
- [x] VirtualBox 7.2.6 kurulu (C:\Program Files\)
- [x] Vagrant 2.4.9 kurulu

## Önemli Not
VBoxManage.exe yolu: C:\Program Files\VBoxManage.exe

(Standart Oracle klasörü değil, doğrudan Program Files altında)
## M0 - Linux Temelleri Tamamlananlar
- [x] Vagrant ile Ubuntu 22.04 VM kuruldu
- [x] Temel komutlar: whoami, pwd, ls, uname, df, free
- [x] Klasör yapısı oluşturma: mkdir -p
- [x] Dosya oluşturma: echo, cat
- [x] İzin yönetimi: chmod 600

## Sistem Bilgileri
- OS: Ubuntu 22.04.5 LTS
- Kernel: 5.15.0-173-generic
- Disk: 39GB
- RAM: 957MB
- VirtualBox shared folder: /vagrant → C:\Users\Admin\sentinel
  
## Ağ Temelleri Tamamlananlar
- [x] ip addr: ağ kartları ve IP adresleri
- [x] ip route: gateway ve routing tablosu  
- [x] ss -tlnp: dinlenen portlar (22-SSH, 53-DNS)

## M0 Durumu: TAMAMLANDI ✓
## Sonraki: M1 - Git + Bash + Python



"GitHub repo linki veya adını paylaşır mısın? Oradan sentinel.md ve context_m0.md dosyalarını birlikte oluşturalım ve M0'a başlayalım.ok devam edelim11:33Repo linkini göremedim, ama başlayalım.

M0 — Adım 1: Ortam Kurulumu
Önce bilgisayarında ne var kontrol edelim.
Aşağıdaki soruları cevapla:

İşletim sisterin ne? (Windows/Mac/Linux)
VS Code kurulu mu?
Git kurulu mu? Terminal'de git --version yaz, ne çıkıyor?
Docker Desktop kurulu mu?
https://github.com/ahmetyildirimoglu-debug/tryworkplace/blob/main/SENT%C4%B0NEL.md
https://github.com/ahmetyildirimoglu-debug/tryworkplace/blob/main/context_m0.mdwindows
vs code kuruluPS C:\Users\Admin> git --version
git version 2.53.0.windows.1
PS C:\Users\Admin>Docker Desktop kurulu mu? kurulu değil bence!11:35Mükemmel, temel hazır. Şimdi sırayla kuralım.

Docker Desktop Kur

https://www.docker.com/products/docker-desktop adresine git
"Download for Windows" indir ve kur
Kurulum bitince bilgisayarı yeniden başlat
Terminal'de şunu yaz:

docker --version
Çıktıyı buraya yapıştır.

Kurulum inerken context_m0.md dosyana şunu ekle:
markdown# Context M0 — Ortam Kurulumu

## Tarih: başlangıç
## Durum: devam ediyor

## Tamamlananlar
- [x] GitHub repo açıldı
- [x] VS Code kurulu
- [x] Git 2.53.0 kurulu
- [ ] Docker Desktop kurulumu

## Sistem
- OS: Windows
- Git: 2.53.0

## Sonraki adım
- Docker kurulumu tamamla
- VirtualBox + Vagrant kur
- AWS hesabı aç
Docker inerken AWS hesabın var mı?Docker inerken AWS hesabın var mı? yok ama yatırım maliyetsiz ilerleyebilir miyiz?11:38Evet, tamamen ücretsiz ilerleyebiliriz başlangıçta.

Ücretsiz alternatifler:
AWS yerine şimdilik:

Localstack — AWS'yi bilgisayarında simüle eder, gerçek AWS gibi çalışır, ücretsiz
Minikube — Kubernetes'i localda çalıştırır, EKS'e gerek yok
Docker Desktop — zaten kuruyorsun, içinde her şey var

AWS'e ne zaman geçeriz:

M4-M5 civarında, sistemi anladıktan sonra
AWS Free Tier ile başlarız, 12 ay ücretsiz
Toplam maliyet: 0-5$ arası kontrollü kullanımla


Yani plan şu:
M0-M3 → Tamamen lokal, sıfır maliyet
M4-M5 → AWS Free Tier, neredeyse sıfır
M6+   → Küçük maliyet, ama o noktada 
          zaten iş bulmuş olursun

Docker kurulumu bitti mi? docker --version çıktısını paylaş, bir sonraki adıma geçelim.PS C:\Users\Admin> docker --version
Docker version 29.3.1, build c2be9cc
PS C:\Users\Admin>11:55Mükemmel. Docker hazır.

Şimdi VirtualBox + Vagrant kuruyoruz.
1. VirtualBox:
https://www.virtualbox.org/wiki/Downloads adresine git → "Windows hosts" indir ve kur.
2. Vagrant:
https://developer.hashicorp.com/vagrant/install adresine git → Windows seç, indir ve kur.
Kurulum bitince terminalde şunu yaz:
virtualbox --version
vagrant --version
İkisinin çıktısını paylaş.

Kurulum inerken context_m0.md dosyasını güncelle:
markdown## Tamamlananlar
- [x] GitHub repo açıldı
- [x] VS Code kurulu
- [x] Git 2.53.0 kurulu
- [x] Docker 29.3.1 kurulu
- [ ] VirtualBox kurulumu
- [ ] Vagrant kurulumuPS C:\Users\Admin> virtualbox --version
virtualbox : The term 'virtualbox' is not recognized as the name of a cmdlet, function, script file, or operable progra
m. Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
At line:1 char:1
+ virtualbox --version
+ ~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (virtualbox:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
PS C:\Users\Admin> vagrant --version
Vagrant 2.4.9
PS C:\Users\Admin>Show more12:07Vagrant tamam. VirtualBox kuruldu ama PATH'e eklenmemiş, sorun değil.
Şunu dene:
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
Çıktı ne?PS C:\Users\Admin> "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
At line:1 char:55
+ "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
+                                                       ~~~~~~~
Unexpected token 'version' in expression or statement.
At line:1 char:1
+ "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The '--' operator works only on variables or on properties.
    + CategoryInfo          : ParserError: (:) [], ParentContainsErrorRecordException
    + FullyQualifiedErrorId : UnexpectedToken
PS C:\Users\Admin>Show more12:08PowerShell'de -- sorunu çıkarıyor. Şunu dene:
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --versionPS C:\Users\Admin> & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
& : The term 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' is not recognized as the name of a cmdlet, function, s
cript file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is cor
rect and try again.
At line:1 char:3
+ & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
+   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\Program File...\VBoxManage.exe:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
PS C:\Users\Admin>Show more12:09VirtualBox kurulmamış demek. Şu adımları izle:

1. https://www.virtualbox.org/wiki/Downloads adresine git
2. "Windows hosts" linkine tıkla, .exe indir
3. İndirilen dosyaya çift tıkla, kurulumu tamamla
4. Kurulum bitince bilgisayarı yeniden başlat
5. Sonra tekrar dene:
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version

Kurulum yaparken takıldığın bir adım olursa söyle.00:00:04.222072 VirtualBox VM 7.2.6 r172322 win.amd64 (Jan 30 2026 17:17:49) release log
00:00:04.222074 Log opened 2026-04-11T09:14:23.745664400Z
00:00:04.222074 Build Type: release
00:00:04.222076 OS Product: Windows 11
00:00:04.235937 OS Release: 10.0.22621.4317
00:00:04.235944 OS Service Papastedkurulum yaptım çalışıyor normalde bu da log ları ama terminalde çıkmıyor12:18VirtualBox kurulu ve VM çalışıyor. Log dosyasını paylaştın, sistem sağlıklı görünüyor.
Terminal'de görünmemesi normal, VirtualBox GUI üzerinden çalışıyor.
Şimdi terminal'de şunu dene:
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
Çıktı gelirse VirtualBox hazır. Gelmezse PATH'e ekleyeceğiz, 1 dakika sürer.PS C:\Users\Admin> & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
& : The term 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' is not recognized as the name of a cmdlet, function, s
cript file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is cor
rect and try again.
At line:1 char:3
+ & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
+   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\Program File...\VBoxManage.exe:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
PS C:\Users\Admin>Show more12:19VirtualBox farklı bir konuma kurulmuş. Dosyayı bulalım:
Get-ChildItem "C:\Program Files\*" -Filter "VBoxManage.exe" -Recurse 2>$null
Çıktıyı paylaş.Get-ChildItem "C:\Program Files\*" -Filter "VBoxManage.exe" -Recurse 2>$null12:19Hiç çıktı gelmedi, VBoxManage.exe bulunamadı. C: dışında kurulmuş olabilir:
Get-ChildItem "C:\", "D:\", "E:\" -Filter "VBoxManage.exe" -Recurse -ErrorAction SilentlyContinueGet-ChildItem "C:\", "D:\", "E:\" -Filter "VBoxManage.exe" -Recurse -ErrorAction SilentlyContinue12:19Yine çıktı gelmedi. VirtualBox GUI çalışıyor ama komut satırı araçları kurulmamış demek.
VirtualBox'ı yeniden kur, bu sefer dikkatli:

Başlat menüsünden "VirtualBox" yaz, sağ tık → "Dosya konumunu aç"
Orada hangi klasörde olduğunu gör ve buraya yaz

Veya daha hızlı:
Get-Process | Where-Object {$_.Name -like "*Virtual*"}
Bu çalışan VirtualBox process'ini gösterir, oradan yolu buluruz.PS C:\Users\Admin> Get-Process | Where-Object {$_.Name -like "*Virtual*"}
Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    597      36    84180     128208       0,23  10436   1 VirtualBox
   1207      55  4374348     257880      10,50   5224   1 VirtualBoxVM
     93       4     2092       5552       0,00  15592   1 VirtualBoxVM
     92       8     2948      10884       0,02  17348   1 VirtualBoxVM
PS C:\Users\Admin>12:22Process ID'yi bulduk. Şimdi tam yolu bulalım:
(Get-Process -Id 10436).Path(Get-Process -Id 10436).Path12:22Çıktı ne oldu? Ekrana bir şey yazdı mı?C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Oracle VirtualBox12:22Bu klasör yolu, executable değil. Şunu dene:
(Get-Process -Id 10436).MainModule.FileNamePS C:\Users\Admin> (Get-Process -Id 10436).MainModule.FileName
C:\Program Files\VirtualBox.exe
PS C:\Users\Admin>12:23Buldum. VirtualBox doğrudan C:\Program Files\ altına kurulmuş, alt klasör yok. O yüzden bulamıyorduk.
Şunu dene:
& "C:\Program Files\VBoxManage.exe" --versionPS C:\Users\Admin> & "C:\Program Files\VBoxManage.exe" --version
7.2.6r172322
PS C:\Users\Admin>12:23VirtualBox hazır. Versiyon: 7.2.6
Şimdi context_m0.md dosyasını güncelle:
markdown## Tamamlananlar
- [x] GitHub repo açıldı
- [x] VS Code kurulu
- [x] Git 2.53.0 kurulu
- [x] Docker 29.3.1 kurulu
- [x] VirtualBox 7.2.6 kurulu (C:\Program Files\)
- [x] Vagrant 2.4.9 kurulu

## Önemli Not
VBoxManage.exe yolu: C:\Program Files\VBoxManage.exe
(Standart Oracle klasörü değil, doğrudan Program Files altında)
Şimdi sıradaki adım: ilk Vagrant VM'i ayağa kaldırmak.
Masaüstünde sentinel klasörü oluştur:
mkdir C:\Users\Admin\sentinel
cd C:\Users\Admin\sentinel
Hazır mısın?oluşturdum devam edelim.12:25Şimdi ilk Vagrantfile'ı oluşturuyoruz. Bu dosya sanal makinemizin "tarifi":
cd C:\Users\Admin\sentinel
vagrant init ubuntu/jammy64
Çıktıyı paylaş.PS C:\Users\Admin\sentinel> cd C:\Users\Admin\sentinel
PS C:\Users\Admin\sentinel> vagrant init ubuntu/jammy64
A Vagrantfile has been placed in this directory. You are now
ready to vagrant up your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
vagrantup.com for more information on using Vagrant.
PS C:\Users\Admin\sentinel>12:26Vagrantfile oluşturuldu. Şimdi VM'i başlatıyoruz:
vagrant up
Bu işlem ilk seferinde Ubuntu image'ını indirir, 5-10 dakika sürebilir. Çıktıları paylaş.PS C:\Users\Admin\sentinel> vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'ubuntu/jammy64' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'ubuntu/jammy64'
    default: URL: https://vagrantcloud.com/api/v2/vagrant/ubuntu/jammy64
==> default: Adding box 'ubuntu/jammy64' (v20241002.0.0) for provider: virtualbox
    default: Downloading: https://vagrantcloud.com/ubuntu/boxes/jammy64/versions/20241002.0.0/providers/virtualbox/unknown/vagrant.box
    default:
==> default: Successfully added box 'ubuntu/jammy64' (v20241002.0.0) for 'virtualbox'!
==> default: Importing base box 'ubuntu/jammy64'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'ubuntu/jammy64' version '20241002.0.0' is up to date...
==> default: Setting the name of the VM: sentinel_default_1775899784134_25209
Vagrant is currently configured to create VirtualBox synced folders with
the SharedFoldersEnableSymlinksCreate option enabled. If the Vagrant
guest is not trusted, you may want to disable this option. For more
information on this option, please refer to the VirtualBox manual:
  https://www.virtualbox.org/manual/ch04.html#sharedfolders
This option can be disabled globally with an environment variable:
  VAGRANT_DISABLE_VBOXSYMLINKCREATE=1
or on a per folder basis within the Vagrantfile:
  config.vm.synced_folder '/host/path', '/guest/path', SharedFoldersEnableSymlinksCreate: false
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection aborted. Retrying...
    default: Warning: Connection reset. Retrying...
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: The guest additions on this VM do not match the installed version of
    default: VirtualBox! In most cases this is fine, but in rare cases it can
    default: prevent things such as shared folders from working properly. If you see
    default: shared folder errors, please make sure the guest additions within the
    default: virtual machine match the version of VirtualBox you have installed on
    default: your host and reload your VM.
    default:
    default: Guest Additions Version: 6.0.0 r127566
    default: VirtualBox Version: 7.2
==> default: Mounting shared folders...
    default: C:/Users/Admin/sentinel => /vagrant
PS C:\Users\Admin\sentinel>Show more12:51VM ayağa kalktı! Uyarılar normal, sorun değil.
Şimdi VM'e bağlanalım:
vagrant sshPS C:\Users\Admin\sentinel> vagrant ssh
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 5.15.0-173-generic x86_64)
 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro
 System information as of Sat Apr 11 09:52:00 UTC 2026
  System load:             0.01
  Usage of /:              4.1% of 38.70GB
  Memory usage:            21%
  Swap usage:              0%
  Processes:               100
  Users logged in:         0
  IPv4 address for enp0s3: 10.0.2.15
  IPv6 address for enp0s3: fd17:625c:f037:2:aa:f8ff:fefc:c71b
Expanded Security Maintenance for Applications is not enabled.
0 updates can be applied immediately.
Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status
The list of available updates is more than a week old.
To check for new updates run: sudo apt update
New release '24.04.4 LTS' available.
Run 'do-release-upgrade' to upgrade to it.
vagrant@ubuntu-jammy:~$Show more12:52Ubuntu VM içindesiniz! vagrant@ubuntu-jammy prompt'u bunu gösteriyor.
Şimdi temel Linux komutlarını öğreniyoruz. Bunlar SENTINEL boyunca her gün kullanacağın komutlar:
bashwhoami
bashpwd
bashls -la
Üçünü sırayla çalıştır, çıktıları paylaş.vagrant@ubuntu-jammy:~$ whoami
vagrant
vagrant@ubuntu-jammy:~$ pwd
/home/vagrant
vagrant@ubuntu-jammy:~$ ls -la
total 28
drwxr-x--- 4 vagrant vagrant 4096 Apr 11 09:30 .
drwxr-xr-x 4 root    root    4096 Apr 11 09:30 ..
-rw-r--r-- 1 vagrant vagrant  220 Mar 20 11:28 .bash_logout
-rw-r--r-- 1 vagrant vagrant 3771 Mar 20 11:28 .bashrc
drwx------ 2 vagrant vagrant 4096 Apr 11 09:30 .cache
-rw-r--r-- 1 vagrant vagrant  807 Mar 20 11:28 .profile
drwx------ 2 vagrant vagrant 4096 Apr 11 09:30 .ssh
vagrant@ubuntu-jammy:~$Show more12:53Mükemmel. Şimdi ne gördüğünü açıklayayım:
whoami → vagrant (sen bu kullanıcısın)
pwd → /home/vagrant (şu an bu klasördesin)
ls -la → klasör içeriği, izinler, sahiplik
İzin sütununu oku: drwxr-x---

d = klasör
rwx = sahibi okuyabilir, yazabilir, çalıştırabilir
r-x = grup okuyabilir, çalıştırabilir
--- = diğerleri hiçbir şey yapamaz

Şimdi birkaç temel komut daha:
bashuname -a
bashdf -h
bashfree -m
Çalıştır, ne döndürdüğünü gör. Sonra ne anlama geldiğini açıklayacağım.vagrant@ubuntu-jammy:~$ uname -a
Linux ubuntu-jammy 5.15.0-173-generic #183-Ubuntu SMP Fri Mar 6 13:29:34 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
vagrant@ubuntu-jammy:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
tmpfs            96M  964K   95M   1% /run
/dev/sda1        39G  1.6G   38G   5% /
tmpfs           479M     0  479M   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
vagrant         239G  147G   92G  62% /vagrant
tmpfs            96M  4.0K   96M   1% /run/user/1000
vagrant@ubuntu-jammy:~$ free -m
               total        used        free      shared  buff/cache   available
Mem:             957         181         226           0         548         626
Swap:              0           0           0
vagrant@ubuntu-jammy:~$Show more12:55Sistemi okuyalım:
uname -a → Linux, Ubuntu 22.04, x86_64 mimari
df -h → 39GB disk, sadece 5% dolu. /vagrant = Windows'taki sentinel klasörü buraya bağlı
free -m → 957MB RAM, 181MB kullanımda, sağlıklı
Şimdi ilk gerçek Linux egzersizi. SENTINEL için bir klasör yapısı oluştur:
bashmkdir -p ~/sentinel/{scripts,logs,configs}
ls ~/sentinel/vagrant@ubuntu-jammy:~$ mkdir -p ~/sentinel/{scripts,logs,configs}
ls ~/sentinel/
configs  logs  scripts
vagrant@ubuntu-jammy:~$12:56Tek komutla 3 klasör oluşturdun. {} syntax'ı brace expansion, DevOps'ta çok kullanılır.
Şimdi dosya oluşturma ve düzenleme:
bashecho "SENTINEL projesi başladı" > ~/sentinel/logs/init.log
cat ~/sentinel/logs/init.logSENTINEL projesi başladı
vagrant@ubuntu-jammy:~$12:57Şimdi izinleri öğreniyoruz, güvenlik için kritik:
bashls -la ~/sentinel/logs/
chmod 600 ~/sentinel/logs/init.log
ls -la ~/sentinel/logs/
İkinci ls çıktısında izinlerin değiştiğini göreceksin.vagrant@ubuntu-jammy:~$ ls -la ~/sentinel/logs/
chmod 600 ~/sentinel/logs/init.log
ls -la ~/sentinel/logs/
total 12
drwxrwxr-x 2 vagrant vagrant 4096 Apr 11 09:57 .
drwxrwxr-x 5 vagrant vagrant 4096 Apr 11 09:56 ..
-rw-rw-r-- 1 vagrant vagrant   27 Apr 11 09:57 init.log
total 12
drwxrwxr-x 2 vagrant vagrant 4096 Apr 11 09:57 .
drwxrwxr-x 5 vagrant vagrant 4096 Apr 11 09:56 ..
-rw------- 1 vagrant vagrant   27 Apr 11 09:57 init.log
vagrant@ubuntu-jammy:~$12:58Gördün mü farkı?
-rw-rw-r-- → önce: sahip+grup yazabilir, herkes okuyabilir
-rw------- → sonra: sadece sahip okuyup yazabilir, başkası hiçbir şey yapamaz
Bu DevSecOps'un temelidir. Hassas dosyalar (config, key, şifre) hep 600 olmalı.
Şimdi context_m0.md dosyasını güncelle, sonra bir sonraki konuya geçiyoruz.
GitHub'daki context_m0.md dosyasına şunu ekle:
markdown## M0 - Linux Temelleri Tamamlananlar
- [x] Vagrant ile Ubuntu 22.04 VM kuruldu
- [x] Temel komutlar: whoami, pwd, ls, uname, df, free
- [x] Klasör yapısı oluşturma: mkdir -p
- [x] Dosya oluşturma: echo, cat
- [x] İzin yönetimi: chmod 600

## Sistem Bilgileri
- OS: Ubuntu 22.04.5 LTS
- Kernel: 5.15.0-173-generic
- Disk: 39GB
- RAM: 957MB
- VirtualBox shared folder: /vagrant → C:\Users\Admin\sentinel
Güncelleyince söyle, kullanıcı yönetimine geçiyoruz.güncelledim devam edelim.13:23Kullanıcı yönetimi — Linux'ta çok kritik, özellikle sunucu güvenliği için.
bashsudo useradd -m -s /bin/bash sentinel
sudo passwd sentinel
Şifre soracak, Sentinel123! yaz (ekranda görünmez, normal).succes.. devam edelim.13:25Şimdi kullanıcıyı inceleyelim:
bashid sentinel
cat /etc/passwd | grep sentinel
groups sentinel
Çıktıları paylaş.vagrant@ubuntu-jammy:~$ id sentinel
cat /etc/passwd | grep sentinel
groups sentinel
uid=1002(sentinel) gid=1002(sentinel) groups=1002(sentinel)
sentinel:x:1002:1002::/home/sentinel:/bin/bash
sentinel : sentinel
vagrant@ubuntu-jammy:~$13:25Kullanıcı oluştu. Şimdi sudo yetkisi verelim:
bashsudo usermod -aG sudo sentinel
groups sentinelsudo yetkisi verdim13:26Şimdi kullanıcıya geçelim ve test edelim:
bashsu - sentinel
sudo whoami
Şifre sorarsa Sentinel123! yaz.vagrant@ubuntu-jammy:~$ su - sentinel
sudo whoami
Password:
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
sentinel@ubuntu-jammy:~$şifreyi girdim bu çıktı13:27su - sentinel başarılı, sentinel kullanıcısındasın. Şimdi sudo test et:
bashsudo whoamisentinel@ubuntu-jammy:~$ sudo whoami
[sudo] password for sentinel:
root
sentinel@ubuntu-jammy:~$13:27Mükemmel. root döndü — sentinel kullanıcısı sudo yetkisine sahip.
Vagrant kullanıcısına dön:
bashexit
Sonra süreç yönetimine geçiyoruz.sentinel@ubuntu-jammy:~$ exit
logout
root
vagrant@ubuntu-jammy:~$evet13:28Şimdi süreç yönetimi — sunucuda ne çalışıyor, nasıl kontrol edersin:
bashps aux | head -20
top -bn1 | head -20
Çıktıları paylaş.vagrant@ubuntu-jammy:~$ ps aux | head -20
top -bn1 | head -20
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  1.3 101944 12880 ?        Ss   09:30   0:02 /sbin/init
root           2  0.0  0.0      0     0 ?        S    09:30   0:00 [kthreadd]
root           3  0.0  0.0      0     0 ?        I<   09:30   0:00 [rcu_gp]
root           4  0.0  0.0      0     0 ?        I<   09:30   0:00 [rcu_par_gp]
root           5  0.0  0.0      0     0 ?        I<   09:30   0:00 [slub_flushwq]
root           6  0.0  0.0      0     0 ?        I<   09:30   0:00 [netns]
root           8  0.0  0.0      0     0 ?        I<   09:30   0:00 [kworker/0:0H-events_highpri]
root          10  0.0  0.0      0     0 ?        I<   09:30   0:00 [mm_percpu_wq]
root          11  0.0  0.0      0     0 ?        S    09:30   0:00 [rcu_tasks_rude_]
root          12  0.0  0.0      0     0 ?        S    09:30   0:00 [rcu_tasks_trace]
root          13  0.0  0.0      0     0 ?        S    09:30   0:00 [ksoftirqd/0]
root          14  0.0  0.0      0     0 ?        I    09:30   0:00 [rcu_sched]
root          15  0.0  0.0      0     0 ?        S    09:30   0:00 [migration/0]
root          16  0.0  0.0      0     0 ?        S    09:30   0:00 [idle_inject/0]
root          18  0.0  0.0      0     0 ?        S    09:30   0:00 [cpuhp/0]
root          19  0.0  0.0      0     0 ?        S    09:30   0:00 [cpuhp/1]
root          20  0.0  0.0      0     0 ?        S    09:30   0:00 [idle_inject/1]
root          21  0.0  0.0      0     0 ?        S    09:30   0:00 [migration/1]
root          22  0.0  0.0      0     0 ?        S    09:30   0:00 [ksoftirqd/1]
top - 10:28:35 up 57 min,  1 user,  load average: 0.00, 0.00, 0.00
Tasks:  98 total,   1 running,  97 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :    957.2 total,    239.5 free,    166.5 used,    551.2 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used.    641.6 avail Mem
    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
      1 root      20   0  101944  12880   8404 S   0.0   1.3   0:02.36 systemd
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.02 kthreadd
      3 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 rcu_gp
      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 rcu_par_gp
      5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 slub_flushwq
      6 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 netns
      8 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/0:0H-events_highpri
     10 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 mm_percpu_wq
     11 root      20   0       0      0      0 S   0.0   0.0   0:00.00 rcu_tasks_rude_
     12 root      20   0       0      0      0 S   0.0   0.0   0:00.00 rcu_tasks_trace
     13 root      20   0       0      0      0 S   0.0   0.0   0:00.11 ksoftirqd/0
     14 root      20   0       0      0      0 I   0.0   0.0   0:00.15 rcu_sched
     15 root      rt   0       0      0      0 S   0.0   0.0   0:00.01 migration/0Show more13:29Sistem sağlıklı. Şunları gördük:
ps aux → tüm çalışan süreçler. PID 1 = systemd, Linux'un ana süreci, her şey ondan başlar.
top → 98 süreç, 1 çalışıyor, 97 uyuyor. CPU %100 idle — sistem rahat.
Şimdi ağ temellerine geçiyoruz:
baship addr show
ip route show
ss -tlnpvagrant@ubuntu-jammy:~$ ip addr show
ip route show
ss -tlnp
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:aa:f8:fc:c7:1b brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 metric 100 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 82860sec preferred_lft 82860sec
    inet6 fd17:625c:f037:2:aa:f8ff:fefc:c71b/64 scope global dynamic mngtmpaddr noprefixroute
       valid_lft 86257sec preferred_lft 14257sec
    inet6 fe80::aa:f8ff:fefc:c71b/64 scope link
       valid_lft forever preferred_lft forever
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
8.8.8.8 via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 100
10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 100
State         Recv-Q        Send-Q               Local Address:Port               Peer Address:Port       Process
LISTEN        0             128                        0.0.0.0:22                      0.0.0.0:*
LISTEN        0             4096                 127.0.0.53%lo:53                      0.0.0.0:*
LISTEN        0             128                           [::]:22                         [::]:*
vagrant@ubuntu-jammy:~$Show more13:29Ağı okuyalım:
lo → loopback, 127.0.0.1, sistemin kendisiyle konuşması
enp0s3 → asıl ağ kartı, IP: 10.0.2.15 (VirtualBox NAT)
ip route → default gateway 10.0.2.2, internet bu kapıdan çıkıyor
ss -tlnp → port 22 dinleniyor (SSH), port 53 DNS
Bu bilgiler Jenkins, Docker, Kubernetes kurarken hangi port'un açık olduğunu anlamak için kritik.
M0 tamamlanmak üzere. Son adım — context_m0.md güncelle:
markdown## Ağ Temelleri Tamamlananlar
- [x] ip addr: ağ kartları ve IP adresleri
- [x] ip route: gateway ve routing tablosu  
- [x] ss -tlnp: dinlenen portlar (22-SSH, 53-DNS)

## M0 Durumu: TAMAMLANDI ✓
## Sonraki: M1 - Git + Bash + Python
Güncelleyince exit yaz, Windows terminaline dön ve M1'e başlayalım.ok go on13:35Windows terminalinde olduğundan emin ol:
vagrant@ubuntu-jammy
yerine
PS C:\Users\Admin\sentinel>
görüyor musun?"
