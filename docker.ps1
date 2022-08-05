#!/usr/bin/env pwsh
#
# this is a powershell script for building this project via a docker container
# use like this: ./docker-run make clean
# should work on Windows, plus any *nix with powershell installed.
# 
# current dir is mounted into the container, command is executed inside the docker container there.
# afterwards, the container (not the image) is destroyed. so every command run is a fresh new container

# parse commandline args
# TODO: there are definitely far better ways to do this in powershell. implement.
$docker_cmd,$container_command = $args -split ' ',2

echo "$docker_cmd -> $container_command"

If (!$container_command) {
    $prog_name="./docker.ps1"
    Write-Host "usage:      ${prog_name} [run,exec,pull] <args>`n`n"
    Write-Host "example:    ${prog_name} 'run make clean && make all && ls /tmp'`n            ^ runs these commands inside the docker container,`n              current directory will be mounted inside of it."
    exit -1
}

if ($env:DOCKER_INTERACTIVE_ARGS) {
    $docker_run_interactive_args = $env:DOCKER_INTERACTIVE_ARGS
}

. docker-build/docker-project-build-settings.ps1

# process and generate the final args we will need to actually invoke docker
# this sets a bunch of variables we can use next
. docker-build/docker_build_module/docker-global-build-settings.ps1

Write-Host "command to execute:`n${final_cmd_to_run}"
Invoke-Expression ${final_cmd_to_run}