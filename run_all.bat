@echo off
title Iniciando Backend + Emulador + Flutter App

REM 1. Iniciar el backend en una nueva consola
start cmd /k "cd backend && node server.js"

REM 2. Lanzar emulador
flutter emulators --launch Pixel_8_Pro