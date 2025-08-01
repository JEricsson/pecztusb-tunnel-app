; ===============================================================
;    pecztusb-api Server Installer (v22.1 - Porta Configurável)
; ===============================================================

[Setup]
ArchitecturesInstallIn64BitMode=x64compatible
AppName=pecztusb-api Server
AppVersion=22.1
DefaultDirName={autopf64}\pecztusb_server
OutputBaseFilename=pecztusb-api-server-installer
PrivilegesRequired=admin
SetupIconFile=payload\favicon.ico
RestartIfNeededByRun=yes

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
; Copia os pré-requisitos, drivers e licença para a pasta temporária
Source: "payload\prereqs\*"; DestDir: "{tmp}";
Source: "payload\fabulatech\usb-over-network-server-64bit.msi"; DestDir: "{tmp}";
; Copia os arquivos da nossa aplicação para o diretório de instalação final
Source: "payload\server\*"; DestDir: "{app}\server"; Flags: recursesubdirs createallsubdirs
Source: "payload\nssm.exe"; DestDir: "{app}";
Source: "payload\config.json.template"; DestDir: "{app}";
Source: "payload\README_SERVER.md"; DestDir: "{app}"; Flags: ignoreversion;

[Registry]
; Cria a chave de desinstalação
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\pecztusb_server"; ValueType: string; ValueName: "DisplayName"; ValueData: "pecztusb API Servidor"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\pecztusb_server"; ValueType: string; ValueName: "UninstallString"; ValueData: """{app}\uninstall.exe"""

[Run]
; --- ETAPA 1: INSTALAR PRÉ-REQUISITOS ---
Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/install /quiet /norestart"; Flags: waituntilterminated;

; --- ETAPA 2: INSTALAR DRIVERS FABULATECH ---
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\usb-over-network-server-64bit.msi"" /qn OPEN_URL=0"; Flags: waituntilterminated;

; --- ETAPA 4: CRIAR E INICIAR O SERVIÇO (Modo Normal) ---
Filename: "{app}\nssm.exe"; Parameters: "install PecztusbApiSvc ""{app}\server\server.exe"""; Flags: waituntilterminated;
Filename: "{app}\nssm.exe"; Parameters: "set PecztusbApiSvc AppDirectory ""{app}""";
Filename: "{app}\nssm.exe"; Parameters: "start PecztusbApiSvc";

; --- ETAPA 5: CRIAR CONFIG.JSON A PARTIR DO TOKEN INSERIDO ---
[Code]
var
  Token, ApiPort: String;
  ConfigPage: TWizardPage;
  TokenLabel, ApiPortLabel: TLabel;
  TokenEdit, ApiPortEdit: TEdit;

procedure CreateConfigPage();
begin
  ConfigPage := CreateCustomPage(wpReady, 'Configurações de Conexão', 'Insira os dados de conexão para o serviço.');
  
  TokenLabel := TLabel.Create(ConfigPage);
  TokenLabel.Parent := ConfigPage.Surface;
  TokenLabel.Caption := 'Cole o token do seu túnel Cloudflare aqui:';
  TokenLabel.Top := 10;

  TokenEdit := TEdit.Create(ConfigPage);
  TokenEdit.Parent := ConfigPage.Surface;
  TokenEdit.Top := TokenLabel.Top + TokenLabel.Height + 5;
  TokenEdit.Width := ConfigPage.Surface.Width;

  ApiPortLabel := TLabel.Create(ConfigPage);
  ApiPortLabel.Parent := ConfigPage.Surface;
  ApiPortLabel.Caption := 'Porta da API (Padrão: 5001)';
  ApiPortLabel.Top := TokenEdit.Top + TokenEdit.Height + 15;

  ApiPortEdit := TEdit.Create(ConfigPage);
  ApiPortEdit.Parent := ConfigPage.Surface;
  ApiPortEdit.Top := ApiPortLabel.Top + ApiPortLabel.Height + 5;
  ApiPortEdit.Width := 100;
  ApiPortEdit.Text := '5001';
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  PortNum, ErrorCode: Integer;
begin
  Result := True;
  if CurPageID = ConfigPage.ID then begin
    // Valida o Token
    Token := TokenEdit.Text;
    if Length(Token) < 50 then begin
      MsgBox('O token do Cloudflare parece inválido ou está em branco.', mbError, MB_OK);
      Result := False;
      exit;
    end;

    // Valida a Porta
    ApiPort := Trim(ApiPortEdit.Text);
    // StrToIntDef tenta converter a string; se falhar, retorna -1.
    PortNum := StrToIntDef(ApiPort, -1); 
    
    if (PortNum < 1024) or (PortNum > 65535) then begin
      MsgBox('A porta da API é inválida. Por favor, insira um número entre 1024 e 65535.', mbError, MB_OK);
      Result := False;
    end;        
  end;
end;
  
procedure CurStepChanged(CurStep: TSetupStep);
var
  AppPath: String;
  JsonContent: TStringList;
begin
  if (CurStep = ssPostInstall) then begin
    AppPath := ExpandConstant('{app}');
    
    JsonContent := TStringList.Create;
    try
      JsonContent.Add('{');
      JsonContent.Add('  "cloudflare_token": "' + Token + '",');
      // Garante que a porta seja salva como um número, não como uma string
      JsonContent.Add('  "api_port": ' + ApiPort); 
      JsonContent.Add('}');
      // TEncoding.UTF8 não é nativo, SaveToFile usa a codificação padrão que é compatível
      JsonContent.SaveToFile(AppPath + '\server\config.json'); 
    finally
      JsonContent.Free;
    end;
  end;
end;


procedure InitializeWizard();
begin
  CreateConfigPage();
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ResultCode: Integer;
begin
  if CurUninstallStep = usUninstall then begin
    Exec('nssm.exe', 'stop PecztusbApiSvc', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    Exec('nssm.exe', 'remove PecztusbApiSvc confirm', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    Exec('msiexec.exe', '/x {D0A54D06-D555-49B1-A064-1423536C29A2} /qn', '', SW_HIDE, ewWaitUntilTerminated, ResultCode); 
  end;
end;
