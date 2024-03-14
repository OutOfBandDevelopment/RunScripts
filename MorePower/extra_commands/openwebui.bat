
docker run ^
--rm ^
-p 3001:8080 ^
-e OLLAMA_API_BASE_URL=http://172.17.0.2:11434/api ^
-v open-webui:/app/backend/data ^
--name open-webui ^
ghcr.io/open-webui/open-webui:main


REM -e OLLAMA_API_BASE_URL=http://192.168.1.170:11434/api ^