@ECHO OFF

::�H�t�κ޲z����������
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

echo ���������z���H�t�κ޲z���������桰��

:import
echo.
set /p Keys=���_�e���W��:

set /p KeyPath=���_�e��Ū��/�ץX������|(�txml�ɦW):

set /p ProPath=�M�׵�����|:

::���ʥؿ�
c:
cd C:\Windows\Microsoft.NET\Framework64\v2.0.50727\
cd C:\Windows\Microsoft.NET\Framework64\v4.0.30319\

:List
echo.
echo.
echo (a)�@��[�K
echo (b)�@��ѱK
echo (1)�إߪ��_�e��
echo (2)�������_�e��
echo (3)�ץX���_�e��
echo (4)�פJ���_�e��
echo (5)���_�e���[�K
echo (6)���_�e���ѱK
echo (7)�إ�IIS�v��
echo (8)����IIS�v��
echo (9)WEB.config
echo (h)���U
echo (i)���]�Ѽ�

choice /c:123456789habi /n /m "�п�J����ʧ@�N��:"


:: �����P�_�ƭȳ̰�����^�X
if errorlevel 13 goto import
if errorlevel 12 goto �@��ѱK
if errorlevel 11 goto �@��[�K
if errorlevel 10 goto ���U
if errorlevel 9 goto WEB.config
if errorlevel 8 goto ����IIS�v��
if errorlevel 7 goto �إ�IIS�v��
if errorlevel 6 goto ���_�e���ѱK
if errorlevel 5 goto ���_�e���[�K
if errorlevel 4 goto �פJ���_�e��
if errorlevel 3 goto �ץX���_�e��
if errorlevel 2 goto �������_�e��
if errorlevel 1 goto �إߪ��_�e��


:�@��ѱK
echo �@��ѱK
aspnet_regiis -pdf connectionStrings "%ProPath%"
goto List

:�@��[�K
echo �@��[�K
aspnet_regiis -pef connectionStrings "%ProPath%"
goto List

:�إߪ��_�e��
echo �إߪ��_�e��
aspnet_regiis.exe -pc "%Keys%" -exp
goto List

:�������_�e��
echo �������_�e��
aspnet_regiis.exe -pz "%Keys%"
goto List

:�ץX���_�e��
echo �ץX���_�e��
aspnet_regiis -px "%Keys%" "%KeyPath%" -pri
goto List

:�פJ���_�e��
echo �פJ���_�e��
aspnet_regiis -pi "%Keys%" "%KeyPath%"
goto List

:���_�e���[�K
echo ���_�e���[�K
aspnet_regiis.exe -pef connectionStrings "%ProPath%" -prov "%Keys%"
::aspnet_regiis.exe -pef appSettings  "%ProPath%" -prov "%Keys%"
goto List

:���_�e���ѱK
echo ���_�e���ѱK
aspnet_regiis.exe -pdf connectionStrings "%ProPath%"
goto List

:�إ�IIS�v��
echo �إ�IIS�v��
aspnet_regiis.exe -pa "%Keys%" "NT AUTHORITY\NETWORK SERVICE"
aspnet_regiis.exe -pa "%Keys%" "IIS AppPool\DefaultAppPool"
aspnet_regiis.exe -pa "%Keys%" "IIS_IUSRS"
goto List

:����IIS�v��
echo ����IIS�v��
aspnet_regiis.exe -pr "%Keys%" "NT AUTHORITY\NETWORK SERVICE"
aspnet_regiis.exe -pr "%Keys%" "IIS AppPool\DefaultAppPool"
aspnet_regiis.exe -pr "%Keys%" "IIS_IUSRS"
goto List

:WEB.config
echo WEB.config�зs�W�H�U�r��
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

:���U
echo ���U
echo .
echo .
echo �]�p��
echo .
echo .
goto List


PAUSE
goto List

::RSA�ɮ׸��|
::C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys