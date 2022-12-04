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

:PSBoot
powershell Set-ExecutionPolicy -Force Unrestricted
powershell .\nana.ps1
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v Denied  ^|findstr /ri "REG_DWORD"') do set "ban=%%a"
if %ban%==0x1 exit

:PSSelect
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v Pwsh  ^|findstr /ri "REG_DWORD"') do set "ps=%%a"
if %ps%==0x5 goto BioniDKU5
if %ps%==0x7 goto BioniDKU7
echo Something went wrong and the script couldn't boot. Please contact Bionic. Press any key to exit.
pause > nul

:PSRestart
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v RebootScript  ^|findstr /ri "REG_DWORD"') do set "re=%%a"
if %re%==0x1 echo Time for the script container to restart the script...
if %re%==0x1 goto PSSelect
exit

:BioniDKU5
timeout 1 /nobreak > nul
powershell .\main5.ps1
goto PSRestart

:BioniDKU7
timeout 1 /nobreak > nul
"C:\Program Files\PowerShell\7\pwsh.exe" .\main7.ps1
goto PSRestart

