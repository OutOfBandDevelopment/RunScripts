# Run Scripts

## Summary

This collection of scripts will allow running these various commands from docker
allowing these to be ran acting local without actually installing these platforms
on your system.

The mappings are defined in [command_def.yaml](./MorePower/template_commands/command_def.yaml)
The `.js` and `.hbs` files in the same directory may be used generate additional commands

## Notes

You might need to disable entry points in the `manage app execution aliases` for
windows (ie python.exe)

If you have memory issues with WSL you might be interested in this [config](https://gist.github.com/mwwhited/6a959dc323c858bf854de7ff045dc0c0)

You might need to fix up permissions on OS-X and Linux.  Within this folder execute
`chmod +x * && chmod -x *.bat && chmod -x LICENSE && chmod -x *.md` to add execute 
to the commands if not assigned

## Extensions

### Pre/Post execution

If you want to run commands before these scripts you can create a file in your
working directory named `before_docker.bat` or `before_docker.cmd`.  To run
commands after use `after_docker.bat` or `after_docker.cmd`.  On Linux or OS-X
these are `before_docker.sh` and `after_docker.cmd`.

### Extension Parameters

If you want to add extra parameters to the docker command for your script just
set the environment variable `EXTRA_DOCKER_COMMANDS` to the desired parameters.

## Known Issues

Currently the X11 scripts are only configured to work with WSL on windows.  
It is possible to make these work under Linux and OS-X but that hasn't been 
tested yet.