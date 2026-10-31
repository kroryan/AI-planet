;AIR Engine - Example.nsi
;
;--------------------------------

; The name of the installer
Name "AIR Engine"

; The file to write
OutFile "AIR-Engine-Example-0800.exe"

; The default installation directory
InstallDir "$PROGRAMFILES\AIR Engine"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\AIR Engine" "Install_Dir"

; Adds an XP manifest to the installer
XPStyle on

; Sets the font of the installer
SetFont "Courier New" 10

LicenseText "AIR Engine Example Readme"
LicenseData "..\AIR Engine\readme.txt"

;--------------------------------

; Pages

Page license
Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "AIR Engine"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File /r "..\AIR Engine\*.*"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\AIR Engine" "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AIR Engine" "DisplayName" "AIR Engine Example"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AIR Engine" "UninstallString" '"$INSTDIR\air-engine-uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AIR Engine" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AIR Engine" "NoRepair" 1
  WriteUninstaller "air-engine-uninstall.exe"
  
SectionEnd

; Optional Start Menu shortcuts
Section "Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\AIR Engine"
  CreateShortCut "$SMPROGRAMS\AIR Engine\AIR Engine - Example.lnk" "$INSTDIR\air.exe" "" "$INSTDIR\air.exe" 0
  CreateShortCut "$SMPROGRAMS\AIR Engine\AIR Engine - Readme.lnk" "$INSTDIR\readme.txt" "" "$INSTDIR\readme.txt" 0
  CreateShortCut "$SMPROGRAMS\AIR Engine\Uninstall AIR Engine Example.lnk" "$INSTDIR\air-engine-uninstall.exe" "" "$INSTDIR\air-engine-uninstall.exe" 0
    
SectionEnd

; Optional Desktop shortcut
Section "Desktop Shortcut"

  Delete "$DESKTOP\AIR Engine - Example.lnk"
  CreateShortCut "$DESKTOP\AIR Engine - Example.lnk" "$INSTDIR\air.exe" "" "$INSTDIR\air.exe" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AIR Engine"
  DeleteRegKey HKLM "SOFTWARE\AIR Engine"

  ; Remove files and uninstaller
  RMDir /r "$INSTDIR\data"
  RMDir /r "$INSTDIR\docs"
  RMDir /r "$INSTDIR\windows"
  RMDir /r "$INSTDIR\photos"
  RMDir /r "$INSTDIR\worlds"
  Delete "$INSTDIR\*.*"

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\AIR Engine\*.*"
  Delete "$DESKTOP\AIR Engine - Example.lnk"

  ; Remove directories used
  RMDir "$SMPROGRAMS\AIR Engine"
  RMDir "$INSTDIR"

SectionEnd
