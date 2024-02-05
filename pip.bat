@docker volume create python-pip-cache
@docker volume create python-pycache
@docker run ^
--rm -it ^
-v %cd%:/usr/src/ ^
-v python-pip-cache:/root/.cache/pip/ ^
-v python-__pycache__:/usr/local/lib/python3.12/ ^
-p 8080:8080 %EXTRA_DOCKER_COMMANDS% ^
-w /usr/src/ ^
python:latest pip %*