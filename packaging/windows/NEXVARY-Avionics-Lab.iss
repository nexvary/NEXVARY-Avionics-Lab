#define MyAppName "NEXVARY Avionics Lab"
#define MyAppVersion "2.0.0"
#define MyAppPublisher "NEXVARY Inc"
#define MyAppExeName "nexvary_avionics_hmi.exe"

[Setup]
AppId={{A65AC47A-86D1-4F5E-AB33-AEC86E71C720}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={localappdata}\Programs\NEXVARY Avionics Lab
DefaultGroupName=NEXVARY Avionics Lab
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=..\..\dist-installer
OutputBaseFilename=NEXVARY-Avionics-Lab-Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
UninstallDisplayName=NEXVARY Avionics Lab
CloseApplications=yes
RestartApplications=no

[Files]
Source: "..\..\package\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\NEXVARY Avionics Lab"; Filename: "{app}\{#MyAppExeName}"
Name: "{userdesktop}\NEXVARY Avionics Lab"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional shortcuts:"; Flags: unchecked

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch NEXVARY Avionics Lab"; Flags: nowait postinstall skipifsilent
