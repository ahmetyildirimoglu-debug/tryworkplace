@echo off
chcp 65001 >nul
title Video Parcalama
cd /d "%~dp0"
if not exist "%~dp0VideoParcala.ps1" (
    echo [!] VideoParcala.ps1 bu klasorde bulunamadi.
    pause
    exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0VideoParcala.ps1"
echo.
pause
