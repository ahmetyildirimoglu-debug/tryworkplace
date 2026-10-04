@echo off
chcp 65001 >nul
title Video Transkript
cd /d "%~dp0"
if not exist "%~dp0Transkript.ps1" (
    echo [!] Transkript.ps1 bu klasorde bulunamadi.
    pause
    exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Transkript.ps1"
echo.
pause
