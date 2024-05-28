
docker build ^
--tag oobdev/comfyui ^
--file ..\DockerFile.comfyui ^
..

IF NOT ERRORLEVEL 0 GOTO :EOF

docker run --rm %EXTRA_DOCKER_COMMANDS% ^
  --gpus all ^
  --publish 8888:8188 ^
  --volume comfyui-workspace-models:/workspace/models ^
  --volume comfyui-workspace-input:/workspace/ComfyUI/input ^
  --volume comfyui-workspace-output:/workspace/ComfyUI/output ^
  oobdev/comfyui %*

@REM --workdir /jupyter/src/ ^