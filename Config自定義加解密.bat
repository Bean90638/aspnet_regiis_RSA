@ECHO OFF

::以系統管理員身分執行
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"

echo ※※提醒您須以系統管理員身分執行※※

:import
echo.
set /p Keys=金鑰容器名稱:

set /p KeyPath=金鑰容器讀取/匯出絕對路徑(含xml檔名):

set /p ProPath=專案絕對路徑:

::移動目錄
c:
cd C:\Windows\Microsoft.NET\Framework64\v2.0.50727\
cd C:\Windows\Microsoft.NET\Framework64\v4.0.30319\

:List
echo.
echo.
echo (a)一般加密
echo (b)一般解密
echo (1)建立金鑰容器
echo (2)移除金鑰容器
echo (3)匯出金鑰容器
echo (4)匯入金鑰容器
echo (5)金鑰容器加密
echo (6)金鑰容器解密
echo (7)建立IIS權限
echo (8)移除IIS權限
echo (9)WEB.config
echo (h)幫助
echo (i)重設參數

choice /c:123456789habi /n /m "請輸入執行動作代號:"


:: 應先判斷數值最高的返回碼
if errorlevel 13 goto import
if errorlevel 12 goto 一般解密
if errorlevel 11 goto 一般加密
if errorlevel 10 goto 幫助
if errorlevel 9 goto WEB.config
if errorlevel 8 goto 移除IIS權限
if errorlevel 7 goto 建立IIS權限
if errorlevel 6 goto 金鑰容器解密
if errorlevel 5 goto 金鑰容器加密
if errorlevel 4 goto 匯入金鑰容器
if errorlevel 3 goto 匯出金鑰容器
if errorlevel 2 goto 移除金鑰容器
if errorlevel 1 goto 建立金鑰容器


:一般解密
echo 一般解密
aspnet_regiis -pdf connectionStrings "%ProPath%"
goto List

:一般加密
echo 一般加密
aspnet_regiis -pef connectionStrings "%ProPath%"
goto List

:建立金鑰容器
echo 建立金鑰容器
aspnet_regiis.exe -pc "%Keys%" -exp
goto List

:移除金鑰容器
echo 移除金鑰容器
aspnet_regiis.exe -pz "%Keys%"
goto List

:匯出金鑰容器
echo 匯出金鑰容器
aspnet_regiis -px "%Keys%" "%KeyPath%" -pri
goto List

:匯入金鑰容器
echo 匯入金鑰容器
aspnet_regiis -pi "%Keys%" "%KeyPath%"
goto List

:金鑰容器加密
echo 金鑰容器加密
aspnet_regiis.exe -pef connectionStrings "%ProPath%" -prov "%Keys%"
::aspnet_regiis.exe -pef appSettings  "%ProPath%" -prov "%Keys%"
goto List

:金鑰容器解密
echo 金鑰容器解密
aspnet_regiis.exe -pdf connectionStrings "%ProPath%"
goto List

:建立IIS權限
echo 建立IIS權限
aspnet_regiis.exe -pa "%Keys%" "NT AUTHORITY\NETWORK SERVICE"
aspnet_regiis.exe -pa "%Keys%" "IIS AppPool\DefaultAppPool"
aspnet_regiis.exe -pa "%Keys%" "IIS_IUSRS"
goto List

:移除IIS權限
echo 移除IIS權限
aspnet_regiis.exe -pr "%Keys%" "NT AUTHORITY\NETWORK SERVICE"
aspnet_regiis.exe -pr "%Keys%" "IIS AppPool\DefaultAppPool"
aspnet_regiis.exe -pr "%Keys%" "IIS_IUSRS"
goto List

:WEB.config
echo WEB.config請新增以下字串
echo.
echo ^<configProtectedData^>
echo 	^<providers^>
echo 		^<add name^="%Keys%"
echo 		type^="System.Configuration.RsaProtectedConfigurationProvider, System.Configuration, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
echo 		keyContainerName^="%Keys%"
echo 		useMachineContainer^="true" /^>
echo 	^</providers^>
echo ^</configProtectedData^>
echo.

PAUSE
goto List

:幫助
echo 幫助
echo .
echo .
echo 設計中
echo .
echo .
goto List


PAUSE
goto List

::RSA檔案路徑
::C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys