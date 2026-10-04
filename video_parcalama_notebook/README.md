# Video Parçalama

Windows için video parçalama aracı. Videoyu **yeniden kodlamadan** (kalite/veri kaybı olmadan) böler.

## Klasör yapısı
```
video_parcalama_notebook\
  VideoParcala.bat        ← çift tıklayın
  VideoParcala.ps1        ← programın kendisi (bat bunu çalıştırır)
  Transkript.bat          ← parçalanmış videoların transkriptini üretir
  Transkript.ps1
  FFmpegKur.bat           ← ilk seferde bir kez çalıştırın
  çalışılacak\            ← parçalanacak videoları buraya koyun
    arşiv\                ← sonuçlar buraya gelir
      <video adı>\        ← o videonun parçaları (video adı_parca001.mp4 ...)
        <video adı>_transkript.txt   ← tüm parçaların metni, sırayla
        transkript\                  ← her parça için .txt ve .srt (zaman kodlu altyazı)
      <video adı>.mp4     ← işlenen orijinal video buraya taşınır
```

## Kullanım
1. İlk seferde `FFmpegKur.bat` dosyasını çalıştırın (ffmpeg'i indirir).
2. Videoları `çalışılacak` klasörüne koyun.
3. `VideoParcala.bat` dosyasına çift tıklayın ve soruları cevaplayın:
   - **[1] Boyuta göre** (varsayılan): her parça en fazla **190 MB** (Enter = 190).
   - **[2] Eşit parçaya göre**: video süre olarak kaç eşit parçaya bölünecek.
   - **Kesimde 2 sn tekrar alınsın mı?** Evet derseniz her parça, bir önceki parçanın son ~2 saniyesiyle başlar; geçişlerde hiçbir an kaçmaz.

## Transkript
1. Videoları önce `VideoParcala.bat` ile parçalayın.
2. `Transkript.bat` dosyasına çift tıklayın. `arşiv` içindeki video klasörleri listelenir:
   - **Enter**: transkripti olmayan klasörlerin hepsi
   - **0**: hepsi (var olanlar yeniden üretilir)
   - **Numaralar** (örn. `1 3`): sadece seçilenler
3. Dili seçin (varsayılan Türkçe).

İlk çalıştırmada transkript aracı ([whisper.cpp](https://github.com/ggml-org/whisper.cpp), ~5 MB) ve konuşma tanıma modeli
(önerilen: ~550 MB) bir kez indirilir ve `whisper` klasörüne kaydedilir. Transkript **bu bilgisayarda** üretilir,
ses hiçbir yere gönderilmez. İşlemciyi yoğun kullanır; süre video uzunluğuna ve bilgisayarın hızına bağlıdır.
2 sn tekrar ile kesilmiş parçalarda, tekrar eden kısımların metni iki parçada da görünür.

## Nasıl çalışır / garantiler
- Video tek geçişte, tam **anahtar karelerden** kesilir; zamana atlama (seek) kullanılmaz.
- Boyut modunda kesim noktaları, her paketin gerçek boyutu okunarak hesaplanır; çıkan **her parça kontrol edilir**, sınırı aşan olursa daha küçük parçalarla yeniden kesilir.
- Sonunda **görüntü karesi ve ses paketi sayıları** orijinalle karşılaştırılır. Eksik varsa orijinal video yerinde bırakılır, arşive taşınmaz.
- 2 sn tekrar bir videoda sınıra sığmıyorsa, o video için **tekrar otomatik iptal edilir**.
- Anahtar kareleri çok seyrek olan videolar (tek bir anahtar kare aralığı bile sınırdan büyükse) yeniden kodlanmadan sınıra sığmaz. Bu durumda program sorar:
  yeniden kodlayarak kes (çok yüksek kalite, ses aynen kopyalanır) veya yine de kayıpsız kes (bazı parçalar sınırı aşar).

## Gereksinim
[ffmpeg](https://ffmpeg.org): `FFmpegKur.bat` ile otomatik indirilir. İsterseniz `ffmpeg.exe` ve `ffprobe.exe` dosyalarını https://www.gyan.dev/ffmpeg/builds/ adresinden elle indirip bu klasöre koyabilirsiniz.

Desteklenen uzantılar: mp4, mkv, mov, avi, wmv, m4v, webm, flv, ts, mts, m2ts, mpg, mpeg, 3gp.
