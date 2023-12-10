:: -----------------------------------------------------------------------
:: Quick Access Popup Context Menu Manager
:: by Dogan Çelik https://github.com/dogancelik/qap-utils
::
:: DESCRIPTION
:: -----------
:: Batch file to install or uninstall Quick Access Popup registry keys
:: for Windows Explorer context menus. For more information:
:: http://www.quickaccesspopup.com/explorer-context-menus-help/
::
:: INSTRUCTIONS
:: ------------
:: 1) Make sure this file is unzipped and saved saved in the same folder
::    as the unzipped files QAPmessenger.exe and QuickAccessPopup.ico.
::
:: 2) You will need ADMINISTRATOR PRIVILEGES to execute this command. To run
::    this batch file as administrator, in Windows Explorer, RIGHT-CLICK its
::    icon and select "Run as administrator".
::
:: 3) In the menu, select "1) Install..." or "2) Uninstall..."
::
:: HISTORY
:: 2017-01-17 Initial release
:: 2017-07-15 Add the context menu "Import Windows shortcut to Quick Access Popup menu"
::
:: -----------------------------------------------------------------------
:: 
@echo off

set "reg_wildcard=HKEY_CLASSES_ROOT\*\shell\"
set "reg_desktop_bg=HKEY_CLASSES_ROOT\DesktopBackground\Shell\"
set "reg_dir_bg=HKEY_CLASSES_ROOT\Directory\Background\shell\"
set "reg_folder=HKEY_CLASSES_ROOT\Folder\shell\"
:: For lnk files, use HKEY_LOCAL_MACHINE\SOFTWARE\Classes\, not HKEY_CLASSES_ROOT\
set "reg_lnkfile=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\lnkfile\shell\"

set "reg1=Add File to Quick Access Popup menu"
set "reg2=Add File to Quick Access Popup menu Express"
set "reg3=Show Quick Access Popup menu"
set "reg4=Show Quick Access Popup Alternative menu"
set "reg5=Add Folder to Quick Access Popup menu"
set "reg6=Add Folder to Quick Access Popup menu Express"
set "reg7=Import Shortcut to Quick Access Popup menu"

set "sep=========================="

echo Welcome to Quick Access Popup Context Menu Manager!
echo (this batch must run as administrator)
echo %sep%
echo 1) Install QAP context menu items
echo 2) Uninstall QAP context menu items
echo 0) Exit
echo %sep%

choice /C 120 /M "Enter your choice:"

if errorlevel 3 goto end
if errorlevel 2 goto uninstall
if errorlevel 1 goto install
goto end

:install
echo Installing QAP context menu items...

set "icon=%~dp0QuickAccessPopup.ico"
set "msn=%~dp0QAPmessenger.exe"

call :regadd "%reg_wildcard%" "%reg1%" "AddFile" 0 0
call :regadd "%reg_wildcard%" "%reg2%" "AddFileXpress" 1 0

call :regadd "%reg_folder%" "%reg5%" "AddFolder" 0 0
call :regadd "%reg_folder%" "%reg6%" "AddFolderXpress" 1 0

call :regadd "%reg_desktop_bg%" "%reg3%" "ShowMenuLaunch" 0 2
call :regadd "%reg_desktop_bg%" "%reg4%" "ShowMenuAlternative" 1 2

call :regadd "%reg_dir_bg%" "%reg3%" "ShowMenuNavigate" 0 2
call :regadd "%reg_dir_bg%" "%reg4%" "ShowMenuAlternative" 1 2

call :regadd "%reg_dir_bg%" "%reg5%" "AddFolder" 0 1
call :regadd "%reg_dir_bg%" "%reg6%" "AddFolderXpress" 1 1

call :regadd "%reg_lnkfile%" "%reg7%" "AddShortcut" 0 0

echo Installed QAP context menu items
goto end

:uninstall
echo Uninstalling QAP context menu items...
reg delete "%reg_wildcard%%reg1%" /f
reg delete "%reg_wildcard%%reg2%" /f
reg delete "%reg_folder%%reg5%" /f
reg delete "%reg_folder%%reg6%" /f
reg delete "%reg_desktop_bg%%reg3%" /f
reg delete "%reg_desktop_bg%%reg4%" /f
reg delete "%reg_dir_bg%%reg3%" /f
reg delete "%reg_dir_bg%%reg4%" /f
reg delete "%reg_dir_bg%%reg5%" /f
reg delete "%reg_dir_bg%%reg6%" /f
reg delete "%reg_lnkfile%%reg7%" /f

echo Uninstalled QAP context menu items
goto end

:end
echo %sep%
echo Program will now exit
pause
exit /B 0

:regadd
set "fullpath=%~1%~2"
reg add "%fullpath%" /ve /d "%~2" /f
reg add "%fullpath%" /v "Icon" /d "%icon%" /f
if %4==1 reg add "%fullpath%" /v "Extended" /d "" /f

set "param=""%%1"""
if %5==1 set "param=""%%V"""
if %5==2 set "param="
reg add "%fullpath%\command" /ve /d "%msn% %3 %param%" /f

exit /B 0
