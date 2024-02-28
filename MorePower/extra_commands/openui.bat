
docker run -d ^
-p 3000:8080 ^
-e OLLAMA_API_BASE_URL=http://192.168.1.170:11434/api ^
-v open-webui:/app/backend/data ^
--name open-webui ^
--restart always ^
ghcr.io/open-webui/open-webui:main