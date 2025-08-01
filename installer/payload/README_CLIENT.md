# Guia Rápido - Uso do Cliente pecztusb

A instalação configurou os drivers necessários para a conexão remota.

---

### **Como Conectar ao Servidor USB Remoto**

1.  Abra o programa **"USB Over Network (Client)"** (você pode encontrá-lo no Menu Iniciar).

2.  Na interface do programa, clique no botão **"Add Server"**.

3.  Na janela que aparecer, preencha os seguintes campos:
    *   **Remote IP address or computer name:** Insira o **hostname público** do túnel TCP fornecido pelo administrador (ex: `usb-server.seudominio.com`).
    *   **TCP-port:** Insira a **porta** correspondente (ex: `33000`).

4.  Clique em **OK**. O servidor remoto deverá aparecer na lista com o status "Online".

5.  Os dispositivos USB compartilhados pelo servidor aparecerão. Selecione o que você deseja e clique em **"Conectar"**.

---

### **Uso Avançado (Linha de Comando)**

Para gerenciar o compartilhamento de dispositivos remotamente (sem usar a GUI do servidor), você pode usar a ferramenta `client.exe`.

1.  Abra um Prompt de Comando ou PowerShell.
2.  Navegue até o diretório de instalação (`C:\Program Files\pecztusb_client`).
3.  Use os comandos, por exemplo:
    ```powershell
    # Para listar dispositivos no servidor
    .\client.exe devices --url https://<seu-hostname-da-api>
    ```