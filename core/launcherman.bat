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
goto BioniDKU

:PSRestartS
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v RebootScript  ^|findstr /ri "REG_DWORD"') do set "re=%%a"
if %re%==0x1 echo Time for the launcher to restart the script...
if %re%==0x1 goto BioniDKU
exit

:Hikarupdate
timeout 1 /nobreak > nul
powershell .\hikarupdate.ps1
goto PSRestartS

:BioniDKU
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v HikaruMode  ^|findstr /ri "REG_DWORD"') do set "hku=%%a"
if %hku%==0x2 goto Hikarupdate
timeout 1 /nobreak > nul
powershell .\main.ps1
goto PSRestartS

echo Something went wrong and the script couldn't boot. Please contact Bionic. Press any key to exit.
pause > nul
