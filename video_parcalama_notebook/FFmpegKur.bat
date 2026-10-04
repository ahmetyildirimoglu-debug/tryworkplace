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
set "HEDEF=%~dp0"

echo Indiriliyor... (yaklasik 80-100 MB, internet hizina gore birkac dakika surebilir)
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;" ^
  "$ProgressPreference='SilentlyContinue';" ^
  "$tmp=$env:GECICI; New-Item -ItemType Directory -Force -Path $tmp | Out-Null;" ^
  "$zip=Join-Path $tmp 'ffmpeg.zip';" ^
  "$urls=@('https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip','https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip');" ^
  "$ok=$false; foreach($u in $urls){ try { Write-Host ('Kaynak: ' + $u); Invoke-WebRequest -Uri $u -OutFile $zip -UseBasicParsing; $ok=$true; break } catch { Write-Host ('  Basarisiz: ' + $_.Exception.Message) } };" ^
  "if(-not $ok){ throw 'Hicbir kaynaktan indirilemedi.' };" ^
  "Write-Host 'Arsivden cikariliyor...';" ^
  "Expand-Archive -LiteralPath $zip -DestinationPath $tmp -Force;" ^
  "foreach($n in 'ffmpeg.exe','ffprobe.exe'){ $f=Get-ChildItem -Path $tmp -Recurse -Filter $n | Select-Object -First 1; if(-not $f){ throw ($n + ' arsivde bulunamadi.') }; Copy-Item -LiteralPath $f.FullName -Destination $env:HEDEF -Force };" ^
  "Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue"
if errorlevel 1 (
    echo.
    echo [!] Kurulum basarisiz oldu. Internet baglantinizi kontrol edin
    echo     veya ffmpeg'i https://www.gyan.dev/ffmpeg/builds/ adresinden
    echo     elle indirip ffmpeg.exe ve ffprobe.exe'yi bu klasore koyun.
    if exist "%GECICI%" rmdir /s /q "%GECICI%"
    goto :cikis
)

echo.
"%~dp0ffmpeg.exe" -hide_banner -version | findstr /b "ffmpeg version"
echo.
echo [OK] ffmpeg basariyla kuruldu. Artik VideoParcala.bat'i kullanabilirsiniz.
goto :cikis

:yeniden_kontrol
if /i "%YENIDEN%"=="E" exit /b 0
exit /b 1

:cikis
echo.
pause
endlocal
