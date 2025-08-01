---

## Spectre Command Console (WebApp de Monitoramento)

O projeto inclui uma aplicação web de front-end, localizada na pasta `/webapp`, para monitorar e controlar os servidores remotamente.

### Funcionalidades

- **Dashboard Centralizado:** Visualize o status de todos os seus servidores em uma única tela.
- **Gerenciamento de Dispositivos:** Liste, compartilhe e pare de compartilhar dispositivos USB através de uma interface gráfica interativa.
- **Configuração Persistente:** A lista de servidores é salva localmente no seu navegador.

### Como Executar o WebApp

1.  Clone este repositório.
2.  Abra o arquivo `webapp/index.html` diretamente em um navegador moderno (Chrome, Firefox, Edge).
3.  Cadastre seus servidores na interface e comece a monitorar.

*(Nota: Para que o WebApp possa se comunicar com as APIs do servidor, a lógica de CORS precisa ser implementada no `server.py`.)*