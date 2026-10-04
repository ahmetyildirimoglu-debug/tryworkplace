@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul
title FFmpeg Kurulumu
cd /d "%~dp0"

echo ==================================================
echo                 FFMPEG KURULUMU
echo ==================================================
echo  ffmpeg.exe ve ffprobe.exe indirilip bu klasore
echo  kopyalanacak:
echo    %~dp0
echo ==================================================
echo.

if exist "%~dp0ffmpeg.exe" if exist "%~dp0ffprobe.exe" (
    echo ffmpeg zaten bu klasorde kurulu.
    set "YENIDEN=H"
    set /p "YENIDEN=Yeniden indirilsin mi? (E/H) [H]: "
    call :yeniden_kontrol
    if errorlevel 1 goto :cikis
)

set "GECICI=%TEMP%\ffmpeg_kurulum_%RANDOM%"
set "ZIP=%GECICI%\ffmpeg.zip"
set "HEDEF=%~dp0"
mkdir "%GECICI%" >nul 2>&1

set "URL1=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
set "URL2=https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"

:: ---------------------------------------------------
:: 1) Indir (ilerleme cubugu ile)
:: ---------------------------------------------------
echo [1/2] Indiriliyor... (100-200 MB; asagida ilerleme gorunur)
echo.
where curl.exe >nul 2>&1
if errorlevel 1 goto :ps_indir

echo Kaynak 1: GitHub
curl.exe -L --fail --retry 2 --connect-timeout 20 --progress-bar -o "%ZIP%" "%URL1%"
if not errorlevel 1 goto :cikar
echo.
echo Kaynak 1 basarisiz, kaynak 2 deneniyor: gyan.dev
curl.exe -L --fail --retry 2 --connect-timeout 20 --progress-bar -o "%ZIP%" "%URL2%"
if not errorlevel 1 goto :cikar
goto :hata

:ps_indir
:: curl yoksa (eski Windows) PowerShell ile indir
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;" ^
  "$wc=New-Object Net.WebClient;" ^
  "foreach($u in @($env:URL1,$env:URL2)){ try { Write-Host ('Kaynak: ' + $u); $wc.DownloadFile($u,$env:ZIP); exit 0 } catch { Write-Host ('  Basarisiz: ' + $_.Exception.Message) } }; exit 1"
if errorlevel 1 goto :hata

:: ---------------------------------------------------
:: 2) Arsivden sadece ffmpeg.exe ve ffprobe.exe'yi cikar
:: ---------------------------------------------------
:cikar
echo.
echo [2/2] Arsivden cikariliyor... (sadece gereken 2 dosya)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "Add-Type -AssemblyName System.IO.Compression.FileSystem;" ^
  "$z=[IO.Compression.ZipFile]::OpenRead($env:ZIP);" ^
  "try { foreach($n in 'ffmpeg.exe','ffprobe.exe'){" ^
  "  $e=$z.Entries | Where-Object { $_.Name -eq $n } | Select-Object -First 1;" ^
  "  if(-not $e){ throw ($n + ' arsivde bulunamadi.') };" ^
  "  [IO.Compression.ZipFileExtensions]::ExtractToFile($e, (Join-Path $env:HEDEF $n), $true);" ^
  "  Write-Host ('  ' + $n + ' tamam') } } finally { $z.Dispose() }"
if errorlevel 1 goto :hata

if exist "%GECICI%" rmdir /s /q "%GECICI%"
echo.
"%~dp0ffmpeg.exe" -hide_banner -version | findstr /b "ffmpeg version"
echo.
echo [OK] ffmpeg basariyla kuruldu. Artik VideoParcala.bat'i kullanabilirsiniz.
goto :cikis

:hata
echo.
echo [!] Kurulum basarisiz oldu. Internet baglantinizi kontrol edin
echo     veya ffmpeg'i elle indirip ffmpeg.exe ve ffprobe.exe'yi bu klasore koyun:
echo     https://www.gyan.dev/ffmpeg/builds/
if exist "%GECICI%" rmdir /s /q "%GECICI%"
goto :cikis

:yeniden_kontrol
if /i "%YENIDEN%"=="E" exit /b 0
exit /b 1

:cikis
echo.
pause
endlocal
