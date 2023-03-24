@echo off
set cwd=%~dp0
@powershell -NoProfile -ExecutionPolicy Unrestricted -Command Start-Process "powershell.exe -ArgumentList %cwd%Install.ps1"