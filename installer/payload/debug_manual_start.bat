@echo off
setlocal

:: ====================================================================
::     Ferramenta de Diagnostico e Inicio Manual (v2 - Automatizada)
:: ====================================================================
echo.
echo ATENCAO: Este script e para fins de depuracao.
echo Ele ira parar os servicos existentes e iniciar a API e o Tunel
echo em duas janelas de console separadas para monitoramento.
echo.
echo Fechar qualquer uma das novas janelas ira parar a operacao.
echo.
echo Por favor, execute-o como Administrador.
echo.
pause

:: --- PASSO 1: Parar qualquer servico existente ---
echo Parando servicos existentes...
nssm.exe stop PecztusbApiSvc > nul 2>&1
nssm.exe stop WinCoreApiSvc > nul 2>&1
echo Servicos parados.
echo.

:: --- PASSO 2: Encontrar e ler o token do config.json ---
echo Lendo token do arquivo config.json...
set "CONFIG_FILE=%~dp0\server\config.json"

if not exist "%CONFIG_FILE%" (
    echo ERRO: Arquivo '%CONFIG_FILE%' nao encontrado.
    pause
    exit /b
)

:: Truque para extrair o valor do token do JSON
for /f "tokens=2 delims=:," %%a in ('findstr /r "cloudflare_token" "%CONFIG_FILE%"') do (
    set "TOKEN_VALUE=%%a"
)

:: Remove aspas e espaços em branco do valor extraído
set "TOKEN_VALUE=%TOKEN_VALUE:"=%"
set "TOKEN_VALUE=%TOKEN_VALUE: =%"

if "%TOKEN_VALUE%"=="" or "%TOKEN_VALUE%"=="SEU_TOKEN_CLOUDFLARE_AQUI" (
    echo ERRO: Token nao configurado ou invalido no config.json.
    pause
    exit /b
)

echo Token encontrado com sucesso.
echo.

:: --- PASSO 3: Iniciar os componentes em janelas separadas ---
echo Iniciando a API e o Tunel em novas janelas...

:: Inicia a API (server.exe) em sua própria janela
start "Pecztusb API" cmd /c "cd /d "%~dp0\server" && server.exe && pause"

:: Inicia o Tunel (cloudflared.exe) em sua própria janela com o token lido
start "Cloudflare Tunnel" cmd /c "cd /d "%~dp0" && cloudflared.exe tunnel run --token %TOKEN_VALUE% && pause"

echo.
echo Janelas de diagnostico iniciadas. Monitore a saida em cada uma.
echo.

endlocal