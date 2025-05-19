@echo off
title Iniciando Backend y la app en Chrome

REM 1. Inicia el backend en una nueva consola
start cmd /k "cd backend && node server.js"

REM 2. Lanzar la aplicación Flutter en Chrome en modo Debug en una nueva consola
start cmd /k "cd flutter && flutter run -d chrome"