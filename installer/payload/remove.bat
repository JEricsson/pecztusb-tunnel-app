@echo off
setlocal

:: ===============================================================
::        Script de Remoção Completa para pecztusb (Modo Furtivo)
:: ===============================================================

:: 1. Verifica se está sendo executado como Administrador
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo.
    echo ERRO: Este script precisa ser executado como Administrador.
    echo Clique com o botao direito e selecione "Executar como administrador".
    echo.
    pause
    exit /b
)

:: Define as variáveis para facilitar a manutenção
set SERVICE_NAME=WinCoreApiSvc
:: !! ATENÇÃO: Substitua este GUID pelo ProductCode REAL do seu 'usb-over-network-server-64bit.msi' !!
set FABULATECH_GUID={B056525E-39F8-40B1-884E-2947E45C45B9}

echo --- Iniciando remoção completa do pecztusb (Modo Furtivo) ---

:: 2. Para e remove nosso serviço principal
echo.
echo [PASSO 1 de 3] Parando e removendo o servico %SERVICE_NAME%...
nssm.exe stop %SERVICE_NAME% > nul 2>&1
nssm.exe remove %SERVICE_NAME% confirm > nul 2>&1
echo Servico removido.

:: 3. Desinstala o software/driver da FabulaTech silenciosamente
echo.
echo [PASSO 2 de 3] Desinstalando drivers da FabulaTech...
msiexec.exe /x %FABULATECH_GUID% /qn
echo Drivers removidos.

:: 4. Apaga a pasta da aplicação e se auto-destroi
echo.
echo [PASSO 3 de 3] Removendo arquivos da aplicacao...
echo A janela do terminal sera fechada. A remocao sera concluida em segundo plano.
timeout /t 3 /nobreak > nul

:: Cria um script temporário para apagar a pasta atual
(
  echo @echo off
  echo rem --- Script de limpeza final ---
  echo timeout /t 2 /nobreak ^> nul
  echo rmdir /s /q "%~dp0"
) > "%TEMP%\pecz_cleanup.bat"

start "" /min "%TEMP%\pecz_cleanup.bat"

exit /b