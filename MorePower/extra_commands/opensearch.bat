
@ECHO OFF
SETLOCAL



IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" %SCRIPT_NAME%
SET SCRIPT_ROOT=%~dp0

REM ... you know better than this. set a value in the script noted above
IF "%OPENSEARCH_ADMIN_PASSWORD%"=="" SET OPENSEARCH_ADMIN_PASSWORD=password

REM https://hub.docker.com/r/opensearchproject/opensearch

docker run ^
-it ^
-p 9200:9200 ^
-p 9600:9600 ^
-e OPENSEARCH_INITIAL_ADMIN_PASSWORD=%OPENSEARCH_ADMIN_PASSWORD% ^
-e "discovery.type=single-node" ^
-e "plugins.security.disabled=true" ^
--name opensearch ^
opensearchproject/opensearch:latest

@REM REM https://hub.docker.com/r/opensearchproject/opensearch-dashboards
@REM REM https://www.opensearch.org/docs/latest/dashboards/
@REM REM https://opensearch.org/docs/latest/install-and-configure/install-opensearch/docker/

@REM docker run --rm -it -p 5601:5601 -e OPENSEARCH_HOSTS_0=http://192.168.1.170:9200  --name opensearch-dashboards opensearchproject/opensearch-dashboards:latest



IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" %SCRIPT_NAME%

:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~f1
  EXIT /B