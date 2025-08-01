; ===============================================================
;                pecztusb Cliente Installer (v2.0 - com Túnel Reverso)
; ===============================================================

[Setup]
ArchitecturesInstallIn64BitMode=x64compatible
AppName=pecztusb Cliente
AppVersion=2.0
DefaultDirName={autopf64}\pecztusb_client
OutputBaseFilename=pecztusb-api-client-installer
PrivilegesRequired=admin
SetupIconFile=payload\favicon.ico
RestartIfNeededByRun=yes

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
; Copia os pré-requisitos e drivers do CLIENTE para a pasta temporária
Source: "payload\prereqs\*"; DestDir: "{tmp}";
Source: "payload\fabulatech\usb-over-network-client-64bit.msi"; DestDir: "{tmp}";
; Copia os arquivos da nossa aplicação para o diretório de instalação final
Source: "payload\client\*"; DestDir: "{app}\client"; Flags: recursesubdirs createallsubdirs
Source: "payload\cloudflared.exe"; DestDir: "{app}";
Source: "payload\nssm.exe"; DestDir: "{app}";
; Copia o README do Cliente, mas apenas se o modo Cliente for selecionado
Source: "payload\README_CLIENT.md"; DestDir: "{app}";

[Registry]
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\pecztusb_client"; ValueType: string; ValueName: "DisplayName"; ValueData: "pecztusb Cliente"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\pecztusb_client"; ValueType: string; ValueName: "UninstallString"; ValueData: """{uninstallexe}"""

[Run]
; --- ETAPA 1: INSTALAR PRÉ-REQUISITOS ---
Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/install /quiet /norestart";

; --- ETAPA 2: INSTALAR DRIVERS DO CLIENTE FABULATECH ---
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\usb-over-network-client-64bit.msi"" /qn INSTALLMENUSHORTCUTS="""" INSTALLDESKTOPSHORTCUTS="""" OPEN_URL=0 CHECK_FOR_NEW_VERSION=0";

; --- ETAPA 3: CRIAR E INICIAR O SERVIÇO DE TÚNEL REVERSO ---
Filename: "{app}\nssm.exe"; Parameters: "install PecztusbClientTunnelSvc ""{app}\cloudflared.exe"" ""access tcp --hostname {code:GetTunnelHostname} --url 127.0.0.1:{code:GetTunnelPort}""";
Filename: "{app}\nssm.exe"; Parameters: "set PecztusbClientTunnelSvc AppDirectory ""{app}""";
Filename: "{app}\nssm.exe"; Parameters: "start PecztusbClientTunnelSvc";

[Code]
var
  TunnelHostname, TunnelPort: String;
  ConfigPage: TWizardPage;
  HostnameLabel, PortLabel: TLabel;
  HostnameEdit, PortEdit: TEdit;

procedure CreateConfigPage();
begin
  ConfigPage := CreateCustomPage(wpReady, 'Configuração do Túnel', 'Insira os detalhes do servidor USB remoto.');
  
  HostnameLabel := TLabel.Create(ConfigPage); HostnameLabel.Parent := ConfigPage.Surface; HostnameLabel.Caption := 'Hostname do Túnel TCP (ex: usb-server.dominio.com):'; HostnameLabel.Top := 10;
  HostnameEdit := TEdit.Create(ConfigPage); HostnameEdit.Parent := ConfigPage.Surface; HostnameEdit.Top := HostnameLabel.Top + HostnameLabel.Height + 5; HostnameEdit.Width := ConfigPage.Surface.Width;
  
  PortLabel := TLabel.Create(ConfigPage); PortLabel.Parent := ConfigPage.Surface; PortLabel.Caption := 'Porta TCP do Servidor Remoto (ex: 33000):'; PortLabel.Top := HostnameEdit.Top + HostnameEdit.Height + 10;
  PortEdit := TEdit.Create(ConfigPage); PortEdit.Parent := ConfigPage.Surface; PortEdit.Top := PortLabel.Top + PortLabel.Height + 5; PortEdit.Width := 100; PortEdit.Text := '33000';
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = ConfigPage.ID then
  begin
    TunnelHostname := HostnameEdit.Text;
    TunnelPort := PortEdit.Text;
    if (Length(TunnelHostname) < 5) or (Length(TunnelPort) < 2) then
    begin
      MsgBox('Por favor, insira um hostname e uma porta válidos.', mbError, MB_OK);
      Result := False;
    end;
  end;
end;

function GetTunnelHostname(Param: String): String; begin Result := TunnelHostname; end;
function GetTunnelPort(Param: String): String; begin Result := TunnelPort; end;

procedure InitializeWizard();
begin
  CreateConfigPage();
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ResultCode: Integer;
begin
  if CurUninstallStep = usUninstall then begin
    Exec('nssm.exe', 'stop PecztusbClientTunnelSvc', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    Exec('nssm.exe', 'remove PecztusbClientTunnelSvc confirm', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    Exec('msiexec.exe', '/x {08BB7651-0E66-492C-AAA3-417BEAFDB1C7} /qn', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;
end;