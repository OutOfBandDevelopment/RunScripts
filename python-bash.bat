@docker volume create python-pip-cache
@docker volume create python-pycache
@docker run ^
--rm -it ^
-v %cd%:/usr/src/ ^
-v python-pip-cache:/root/.cache/pip/ ^
-v python-__pycache__:/usr/local/lib/python3.12/ ^
-w /usr/src/ ^
python:latest bash %*