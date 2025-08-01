*** Guia Rápido - pecztusb Servidor ***
===============================================

A instalação dos componentes foi concluída com sucesso.
Para finalizar a configuração, por favor, siga estes 3 passos manuais:


1. ATIVAR A LICENÇA:
   - Abra o programa "USB Over Network (Server)" pelo seu Menu Iniciar.
   - Uma janela pedindo a chave de licença aparecerá.
   - Copie e cole sua chave de licença para ativar a versão completa e clique em OK.


2. CONFIGURAR O TÚNEL CLOUDFLARE:
   - Navegue até o diretório de instalação:
     C:\Program Files\pecztusb_server  (ou o local que você escolheu)
   - Abra o arquivo "config.json" em um editor de texto.
   - Substitua "SEU_TOKEN_CLOUDFLARE_AQUI" pelo seu token de túnel real.


3. INICIAR O SERVIÇO:
   - Abra o menu "Serviços" do Windows (procure por "services.msc").
   - Encontre o serviço na lista (o nome será "PecztusbApiSvc" ou "WinCoreApiSvc" no modo furtivo).
   - Clique com o botão direito nele e selecione "Iniciar".


Após estes passos, seu servidor estará totalmente configurado e online.
O compartilhamento de dispositivos é feito pela interface do "USB Over Network (Server)".
O controle remoto do compartilhamento pode ser feito via API.