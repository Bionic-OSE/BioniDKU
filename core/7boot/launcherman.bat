@echo off
title BioniDKU is starting...

:#############################################################
if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:#############################################################
rem From: https://serverfault.com/a/886916
set "_title=BioniDKU_MagicID:%random%"
title %_title%
for /f "tokens=2" %%G in ('tasklist /V ^| findstr "%_title%"') do (
    set "_myProcessID=%%~G"
)
title BioniDKU is starting...
:#############################################################

:PSBoot
powershell Set-ExecutionPolicy -Force Bypass
powershell .\nana.ps1
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v Denied  ^|findstr /ri "REG_DWORD"') do set "ban=%%a"
if %ban%==0x1 exit
goto PSwitch

:PSRestart
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v RebootScript  ^|findstr /ri "REG_DWORD"') do set "re=%%a"
if %re%==0x1 title BioniDKU is restarting... - DO NOT CLOSE THIS WINDOW
if %re%==0x3 title Please wait...
if %re%==0x1 goto PSwitch
if %re%==0x3 goto PSwitch
echo https://youtu.be/zry4zeN0SHw
exit

:PSwitch
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v HikaruMode  ^|findstr /ri "REG_DWORD"') do set "hku=%%a"
if %hku%==0x0 goto MenuMode
if %hku%==0x1 goto BioniDKU
if %hku%==0x2 goto BioniDKU
if %hku%==0x3 goto UpdateMode
if %hku%==0x4 goto DownloadMode
timeout 1 /nobreak > nul
goto PSRestart

:MenuMode
powershell -Command "$global:cpid = %_myProcessID%; ..\kernel\menu.ps1"
goto PSRestart

:BioniDKU
powershell ..\kernel\main.ps1
goto PSRestart

:UpdateMode
cls
powershell ..\servicing\idkupdate.ps1
goto PSRestart

:DownloadMode
powershell -NonInteractive -Command "$global:cpid = %_myProcessID%; ..\servicing\downloader.ps1"
goto PSRestart

echo Something went severely wrong. Please contact Bionic. Press any key to exit.
pause > nul
