*** Guia Rápido - pecztusb Cliente ***
=======================================

A instalação configurou um túnel de conexão seguro que inicia com o Windows.

COMO CONECTAR:
1. Abra o programa "USB Over Network Client" (instalado no Menu Iniciar).
2. Clique em "Adicionar Servidor".
3. No campo de endereço, digite: localhost
4. No campo da porta, digite a porta que você configurou durante a instalação (padrão: 33000).
5. O servidor remoto aparecerá como se estivesse na sua rede local.

=======================================
USO AVANÇADO (Linha de Comando):

Para gerenciar o compartilhamento de dispositivos remotamente, você pode usar o client.exe.

1. Abra um Prompt de Comando ou PowerShell.
2. Navegue até o diretório de instalação:
   cd "C:\Program Files\pecztusb_client"

3. Use os comandos:
   - Para listar dispositivos no servidor:
     .\client.exe devices --url https://<seu-hostname-da-api>

   - Para compartilhar um dispositivo:
     .\client.exe share --url https://<seu-hostname-da-api> --devID <ID>