
ECHO Load Docker Command Extensions
SET SCRIPT_ROOT=%~dp0
SET EXTRA_DOCKER_COMMANDS=--volume %SCRIPT_ROOT%..\..\:/usr/src/templates/
ECHO %EXTRA_DOCKER_COMMANDS%