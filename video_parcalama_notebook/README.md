# Video Parçalama

Windows için video parçalama aracı. Videoyu **yeniden kodlamadan** (kalite/veri kaybı olmadan) böler.

## Klasör yapısı
```
video_parcalama_notebook\
  VideoParcala.bat        ← çift tıklayın
  VideoParcala.ps1        ← programın kendisi (bat bunu çalıştırır)
  FFmpegKur.bat           ← ilk seferde bir kez çalıştırın
  çalışılacak\            ← parçalanacak videoları buraya koyun
    arşiv\                ← sonuçlar buraya gelir
      <video adı>\        ← o videonun parçaları (video adı_parca001.mp4 ...)
      <video adı>.mp4     ← işlenen orijinal video buraya taşınır
```

## Kullanım
1. İlk seferde `FFmpegKur.bat` dosyasını çalıştırın (ffmpeg'i indirir).
2. Videoları `çalışılacak` klasörüne koyun.
3. `VideoParcala.bat` dosyasına çift tıklayın ve soruları cevaplayın:
   - **[1] Boyuta göre** (varsayılan): her parça en fazla **190 MB** (Enter = 190).
   - **[2] Eşit parçaya göre**: video süre olarak kaç eşit parçaya bölünecek.
   - **Kesimde 2 sn tekrar alınsın mı?** Evet derseniz her parça, bir önceki parçanın son ~2 saniyesiyle başlar; geçişlerde hiçbir an kaçmaz.

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
