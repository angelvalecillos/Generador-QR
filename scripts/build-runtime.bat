@echo off
setlocal

REM Ir al directorio raiz del proyecto (subir desde /scripts)
set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%\.."

REM ---- CONFIGURAR JAVA_HOME AQUÍ SI ES NECESARIO ----
REM Descomenta y ajusta la siguiente linea si no tienes JAVA_HOME:
REM set "JAVA_HOME=C:\Program Files\OpenJDK\jdk-24.0.2"

REM Localizar jlink
set "JLINK="
if defined JAVA_HOME (
  if exist "%JAVA_HOME%\bin\jlink.exe" set "JLINK=%JAVA_HOME%\bin\jlink.exe"
)

if not defined JLINK (
  where jlink >nul 2>nul
  if errorlevel 1 (
    echo [ERROR] No se encontró jlink. Configura JAVA_HOME o asegúrate de tener un JDK instalado.
    echo         Ejemplo de JAVA_HOME: C:\Program Files\OpenJDK\jdk-24.0.2
    goto :end
  ) else (
    set "JLINK=jlink"
  )
)

REM Crear carpeta target si no existe
if not exist "target" mkdir "target"

echo [INFO] Generando runtime mínimo en %CD%\target\jre
"%JLINK%" --add-modules java.base,java.desktop,java.logging ^
  --output target\jre ^
  --strip-debug --no-header-files --no-man-pages --compress=2

if errorlevel 1 (
  echo [ERROR] Falló jlink. Revisa los mensajes de arriba.
) else (
  echo [OK] Runtime creado en target\jre
)

:end
popd
pause