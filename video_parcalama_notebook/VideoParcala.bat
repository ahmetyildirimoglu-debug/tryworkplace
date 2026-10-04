@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul
title Video Parcalama
cd /d "%~dp0"

echo ==================================================
echo                VIDEO PARCALAMA ARACI
echo ==================================================
echo.

:: ---------------------------------------------------
:: 1) ffmpeg / ffprobe bul (once bu klasor, sonra PATH)
:: ---------------------------------------------------
set "FFMPEG="
set "FFPROBE="
if exist "%~dp0ffmpeg.exe"  set "FFMPEG=%~dp0ffmpeg.exe"
if exist "%~dp0ffprobe.exe" set "FFPROBE=%~dp0ffprobe.exe"
if not defined FFMPEG  for /f "delims=" %%p in ('where ffmpeg 2^>nul')  do if not defined FFMPEG  set "FFMPEG=%%p"
if not defined FFPROBE for /f "delims=" %%p in ('where ffprobe 2^>nul') do if not defined FFPROBE set "FFPROBE=%%p"

if defined FFMPEG if defined FFPROBE goto :ffmpeg_tamam

echo [!] ffmpeg bulunamadi. Bu program video kesmek icin ffmpeg kullanir.
echo.
echo  Secenek 1: ffmpeg.exe ve ffprobe.exe dosyalarini bu klasore koyun:
echo             %~dp0
echo  Secenek 2: Simdi otomatik kurulum (winget ile).
echo.
set "KUR=H"
set /p "KUR=Otomatik kurulsun mu? (E/H) [H]: "
if /i not "%KUR%"=="E" goto :cikis
winget install --id Gyan.FFmpeg -e --accept-source-agreements --accept-package-agreements
echo.
echo Kurulum bitti. Lutfen bu pencereyi kapatip programi yeniden calistirin.
goto :cikis

:ffmpeg_tamam

:: ---------------------------------------------------
:: 2) Klasor (veya tek video) sor
:: ---------------------------------------------------
:klasor_sor
set "KAYNAK="
if not defined ARG_KULLANILDI set "KAYNAK=%~1"
set "ARG_KULLANILDI=1"
if defined KAYNAK goto :klasor_kontrol
echo Videolarin bulundugu KLASORU (veya tek bir video dosyasini)
echo bu pencereye surukleyip birakin ve Enter'a basin:
set /p "KAYNAK=> "

:klasor_kontrol
if not defined KAYNAK goto :klasor_sor
set "KAYNAK=%KAYNAK:"=%"
if "%KAYNAK:~-1%"=="\" set "KAYNAK=%KAYNAK:~0,-1%"
if not exist "%KAYNAK%" (
    echo [!] Bulunamadi: "%KAYNAK%"
    echo.
    goto :klasor_sor
)

:: ---------------------------------------------------
:: 3) Parcalama yontemi
:: ---------------------------------------------------
echo.
echo Nasil parcalansin?
echo   [1] Boyuta gore  (her parca en fazla X MB)  ^<-- varsayilan
echo   [2] Esit parcaya gore (kac parca olacak)
set "MOD=1"
set /p "MOD=Seciminiz (1/2) [1]: "
if "%MOD%"=="2" goto :parca_sor
set "MOD=1"

:mb_sor
set "MB=190"
set /p "MB=Parca boyutu kac MB olsun? [190]: "
set "MBNUM=0"
set /a "MBNUM=MB" 2>nul
if "%MBNUM%"=="%MB%" if %MBNUM% GTR 0 goto :basla
echo [!] Lutfen pozitif bir tam sayi girin.
goto :mb_sor

:parca_sor
set "PARCA="
set /p "PARCA=Kac esit parcaya bolunsun? : "
set "PNUM=0"
set /a "PNUM=PARCA" 2>nul
if "%PNUM%"=="%PARCA%" if %PNUM% GEQ 2 goto :basla
echo [!] Lutfen 2 veya daha buyuk bir tam sayi girin.
goto :parca_sor

:: ---------------------------------------------------
:: 4) Videolari isle
:: ---------------------------------------------------
:basla
set /a ADET=0
if exist "%KAYNAK%\*" goto :klasor_isle
call :isle "%KAYNAK%"
for %%K in ("%KAYNAK%") do set "ACILACAK=%%~dpKparcalar"
goto :bitti

:klasor_isle
for %%F in ("%KAYNAK%\*.mp4" "%KAYNAK%\*.mkv" "%KAYNAK%\*.mov" "%KAYNAK%\*.avi" "%KAYNAK%\*.wmv" "%KAYNAK%\*.m4v" "%KAYNAK%\*.webm" "%KAYNAK%\*.flv" "%KAYNAK%\*.ts" "%KAYNAK%\*.mpg" "%KAYNAK%\*.mpeg" "%KAYNAK%\*.3gp") do call :isle "%%~fF"
set "ACILACAK=%KAYNAK%\parcalar"
if %ADET%==0 echo [!] Klasorde desteklenen video bulunamadi.

:bitti
echo.
echo ==================================================
echo  Islem tamamlandi. Islenen video sayisi: %ADET%
echo  Parcalar: "%ACILACAK%"
echo ==================================================
if exist "%ACILACAK%" start "" explorer "%ACILACAK%"
echo.
set "TEKRAR=H"
set /p "TEKRAR=Baska bir klasor/video parcalamak ister misiniz? (E/H) [H]: "
if /i not "%TEKRAR%"=="E" goto :cikis
cls
goto :klasor_sor

:: ===================================================
:: Tek bir videoyu parcalayan alt program
:: ===================================================
:isle
set "GIRDI=%~f1"
set "AD=%~n1"
set "UZ=%~x1"
set "BOYUT=%~z1"
set "CIKTI=%~dp1parcalar\%~n1"
set /a ADET+=1
echo.
echo --------------------------------------------------
echo  Video : %~nx1
echo --------------------------------------------------

set "SURE="
for /f "delims=" %%d in ('call "%FFPROBE%" -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "%GIRDI%"') do if not defined SURE set "SURE=%%d"
if not defined SURE (
    echo [!] Video suresi okunamadi, atlaniyor.
    exit /b
)

set "SEG="
if "%MOD%"=="2" goto :isle_esit

:: Boyut modu: hedefin %%95'i kadar sure hesapla (anahtar kare payi)
for /f "delims=" %%s in ('powershell -NoProfile -Command "$lim=[double]%MB%*1048576; $b=[double]'%BOYUT%'; if($b -le $lim){'ATLA'}else{([double]'%SURE%'*$lim*0.95/$b).ToString('0.###',[cultureinfo]::InvariantCulture)}"') do set "SEG=%%s"
if "%SEG%"=="ATLA" (
    echo  Video zaten %MB% MB'dan kucuk, parcalamaya gerek yok.
    exit /b
)
echo  Hedef : her parca en fazla %MB% MB  ^(parca suresi ~%SEG% sn^)
goto :isle_kes

:isle_esit
for /f "delims=" %%s in ('powershell -NoProfile -Command "([double]'%SURE%'/%PARCA%).ToString('0.###',[cultureinfo]::InvariantCulture)"') do set "SEG=%%s"
echo  Hedef : %PARCA% esit parca  ^(parca suresi ~%SEG% sn^)

:isle_kes
if not defined SEG (
    echo [!] Hesaplama yapilamadi, atlaniyor.
    exit /b
)
if not exist "%CIKTI%" mkdir "%CIKTI%"
"%FFMPEG%" -hide_banner -loglevel error -stats -y -i "%GIRDI%" -map 0:v:0 -map 0:a? -c copy -f segment -segment_time %SEG% -reset_timestamps 1 "%CIKTI%\%AD%_parca%%03d%UZ%"
if errorlevel 1 (
    echo [!] ffmpeg hata verdi: %~nx1
    exit /b
)
echo  Olusan parcalar:
powershell -NoProfile -Command "Get-ChildItem -LiteralPath $env:CIKTI -File | Sort-Object Name | ForEach-Object { '   {0}   {1} MB' -f $_.Name, ($_.Length/1MB).ToString('0.0',[cultureinfo]::InvariantCulture) }"
exit /b

:cikis
echo.
pause
endlocal
