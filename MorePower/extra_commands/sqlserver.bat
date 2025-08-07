@ECHO OFF
SETLOCAL

IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" %SCRIPT_NAME%
SET SCRIPT_ROOT=%~dp0

REM ... you know better than this. set a value in the script noted above
IF "%MSSQL_SA_PASSWORD%"=="" SET MSSQL_SA_PASSWORD=password

IF "%MSSQL_BACKUP_PATH%"=="" SET MSSQL_BACKUP_PATH=%SCRIPT_ROOT%..\..\..\Backups
CALL :NORMALIZEPATH "%MSSQL_BACKUP_PATH%"
SET MSSQL_BACKUP_PATH=%RETVAL%

IF NOT EXIST "%MSSQL_BACKUP_PATH%" MKDIR "%MSSQL_BACKUP_PATH%"

docker volume create sqlserver-data >NUL 2>&1
docker volume create sqlserver-log >NUL 2>&1
docker volume create sqlserver-secrets >NUL 2>&1

docker run ^
--detach ^
--name sqlserver ^
--user root ^
--env "ACCEPT_EULA=Y" ^
--env "MSSQL_SA_PASSWORD=%MSSQL_SA_PASSWORD%" ^
--publish 1433:1433 ^
--volume sqlserver-data:/var/opt/mssql/data ^
--volume sqlserver-log:/var/opt/mssql/log ^
--volume sqlserver-secrets:/var/opt/mssql/secrets ^
--volume "%MSSQL_BACKUP_PATH%":/tmp/backup ^
mcr.microsoft.com/mssql/server:2022-latest

REM sudo /opt/mssql/bin/mssql-conf set filelocation.defaultbackupdir /tmp/backup

IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" %SCRIPT_NAME%

:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~f1
  EXIT /B