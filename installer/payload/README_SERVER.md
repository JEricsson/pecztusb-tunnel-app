# Guia Rápido - Configuração do Servidor pecztusb

A instalação dos componentes foi concluída com sucesso.

Para finalizar a configuração e ativar seu servidor, por favor, siga estes **3 passos manuais obrigatórios**:

---

### **Passo 1: Ativar a Licença do Software**

1.  Abra o programa **"USB Over Network (Server)"** (você pode encontrá-lo no Menu Iniciar).
2.  Uma janela chamada "Enter License Key" aparecerá.
3.  Copie e cole sua chave de licença completa (incluindo as linhas `-----BEGIN...` e `-----END...`).
4.  Clique em **OK** para ativar a versão completa.

---

### **Passo 2: Configurar o Túnel Cloudflare**

1.  Navegue até o diretório de instalação. O caminho padrão é:
    *   `C:\Program Files\pecztusb_server`

2.  Abra o arquivo `config.json` em um editor de texto (como o Bloco de Notas).

3.  Substitua o texto `"SEU_TOKEN_CLOUDFLARE_AQUI"` pelo seu **token de túnel real**.

---

### **Passo 3: Iniciar o Serviço**

1.  Abra o menu "Serviços" do Windows (você pode pesquisar por `services.msc` no Menu Iniciar).
2.  Encontre o serviço na lista. O nome será:
    *   **PecztusbApiSvc** (para o modo normal)
    *   **WinCoreApiSvc** (para o modo furtivo)
3.  Clique com o botão direito no serviço e selecione **"Iniciar"**.

**Após estes passos, seu servidor estará totalmente configurado e online.** O compartilhamento de dispositivos é feito através da interface do "USB Over Network (Server)".