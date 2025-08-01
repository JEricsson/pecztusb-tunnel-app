@echo off
:: ==========================================================
::     Reinicia o Servico pecztusb-api
:: ==========================================================
echo.
echo Este script ira parar e reiniciar o servico PecztusbApiSvc.
echo Por favor, execute-o como Administrador.
echo.
pause

set SERVICE_NAME=PecztusbApiSvc

echo Parando o servico %SERVICE_NAME%...
nssm.exe stop %SERVICE_NAME%

echo.
echo Iniciando o servico %SERVICE_NAME%...
nssm.exe start %SERVICE_NAME%

echo.
echo Operacao concluida. Verifique o status em "Servicos" (services.msc).
pause