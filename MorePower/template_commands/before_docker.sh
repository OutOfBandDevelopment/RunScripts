
echo Load Docker Command Extensions

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXTRA_DOCKER_COMMANDS="--volume $SCRIPT_ROOT/../../:/usr/src/templates/"
echo $SCRIPT_ROOT
echo  $EXTRA_DOCKER_COMMANDS