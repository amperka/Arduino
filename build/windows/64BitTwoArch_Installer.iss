; -- 64BitTwoArch.iss --
; Demonstrates how to install a program built for two different
; architectures (x86 and x64) using a single installer.

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
PrivilegesRequired=poweruser
AppName=Arduino
AppVersion=1.1
DefaultDirName={pf}\Amperka
DefaultGroupName=Amperka
Compression=lzma2
SolidCompression=yes
OutputDir=.
OutputBaseFilename=Arduino_setup
; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
; On all other architectures it will install in "32-bit mode".
ArchitecturesInstallIn64BitMode=x64
; Note: We don't set ProcessorsAllowed because we want this
; installation to run on all architectures (including Itanium,
; since it's capable of running 32-bit code too).

[Files]

; Перечисляем все файлы, которые требуется залить в установщик
Source: "work\*"; Excludes: "*.iss"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; 

; Все файлы для 64-битной архитектуры пишем сюда 
Source: "work\drivers\dpinst-amd64.exe"; DestDir: "{app}\drivers\"; Check: Is64BitInstallMode; AfterInstall: Install_x64    
 
; Все файлы для 86-битной архитектуры пишем сюда. Первый файл в списке должен быть с флагом 'solidbreak'
Source: "work\drivers\dpinst-x86.exe"; DestDir: "{app}\drivers\"; Check: not Is64BitInstallMode; Flags: solidbreak; AfterInstall: Install_x86

; Все файлы, которые требуется запустить после установки дистрибутива
Source: "work\drivers\driver-atmel-bundle-7.0.712.exe"; DestDir: "{app}\drivers\"; AfterInstall: Install_Atmel 

[Icons]
Name: {group}\Arduino от Амперки; Filename: {app}\arduino.exe; WorkingDir: {app}; IconFilename: {app}\lib\arduino_icon.ico; Comment: "Arduino от Амперки"; 
Name: {commondesktop}\Arduino от Амперки; Filename: {app}\arduino.exe; WorkingDir: {app}; IconFilename: {app}\lib\arduino_icon.ico; Comment: "Arduino от Амперки";

; [Tasks]
; Name: StartAfterInstall; Description: Запустить приложение после установки

;Последний экран установки. Можно поставить галочку "запусить приложение" и тд
[Run]

Filename: "{app}\arduino.exe"; Description: "Запустить Arduino"; Flags: postinstall nowait skipifsilent unchecked
; Filename: "{app}\drivers\dpinst-amd64.exe"; Description: "Launch application"; Check: Is64BitInstallMode; Flags: postinstall shellexec waituntilterminated
; Filename: "{app}\drivers\dpinst-x86.exe"; Description: "Launch application"; Check: not Is64BitInstallMode; Flags: postinstall shellexec waituntilterminated

[Code]


procedure Install_Atmel();
var
  ResultCode: Integer;
begin

  if not ShellExec('', ExpandConstant('{app}\drivers\driver-atmel-bundle-7.0.712.exe'), '', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
    MsgBox('Atmel drivers installation failed', mbInformation, MB_OK);
  
end;


procedure Install_x86();
var
  ResultCode: Integer;
begin

  // MsgBox('Installing in 32-bit mode', mbInformation, MB_OK)
  if not ShellExec('', ExpandConstant('{app}\drivers\dpinst-x86.exe'), '', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
    MsgBox('drivers installation failed', mbInformation, MB_OK);
  
end;

procedure Install_x64();
var
  ResultCode: Integer;
begin

  // MsgBox('Installing in 64-bit mode', mbInformation, MB_OK)
  if not ShellExec('', ExpandConstant('{app}\drivers\dpinst-amd64.exe'), '', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
    MsgBox('drivers installation failed', mbInformation, MB_OK);
  
end;

