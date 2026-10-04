# Video Parçalama

Masaüstünde çalışan, Windows için basit video parçalama aracı.

## Kullanım
1. `VideoParcala.bat` dosyasına çift tıklayın (veya bir klasörü/videoyu bat dosyasının üzerine sürükleyip bırakın).
2. Videoların bulunduğu klasörü pencereye sürükleyin ve Enter'a basın.
3. Yöntemi seçin:
   - **[1] Boyuta göre** (varsayılan): her parça en fazla **190 MB** (Enter = 190, isterseniz başka değer yazın).
   - **[2] Eşit parçaya göre**: kaç eşit parçaya bölüneceğini yazın.
4. Parçalar her videonun yanında `parcalar\<video adı>\` klasörüne `video_parca000.mp4`, `video_parca001.mp4` ... şeklinde kaydedilir ve klasör otomatik açılır.

## Gereksinim
[ffmpeg](https://ffmpeg.org). İki seçenek:
- `ffmpeg.exe` ve `ffprobe.exe` dosyalarını bu klasöre koyun, **veya**
- Program ffmpeg bulamazsa otomatik kurmayı teklif eder (`winget install Gyan.FFmpeg`).

## Notlar
- Video yeniden kodlanmaz (`-c copy`), bu yüzden çok hızlıdır ve kalite kaybı olmaz.
- Kesimler anahtar karelerde yapıldığı için boyut modunda %5 güvenlik payı bırakılır; parçalar hedef boyutun biraz altında kalır.
- Desteklenen uzantılar: mp4, mkv, mov, avi, wmv, m4v, webm, flv, ts, mpg, mpeg, 3gp.
