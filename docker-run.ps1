#!/usr/bin/env pwsh
#
# this is a powershell script for building this project via a docker container
# use like this: ./docker-run make clean
# should work on Windows, plus any *nix with powershell installed.
# 
# current dir is mounted into the container, command is executed inside the docker container there.
# afterwards, the container (not the image) is destroyed. so every command run is a fresh new container

$container_command=$args

If (!$container_command) {
    $prog_name="./docker-run.ps1" # there's way better methods than this in powershell. fix
    Write-Host "usage:      ${prog_name} <command>`n`n"
    Write-Host "example:    ${prog_name} make clean && make clean && ls /tmp`n            ^ runs these commands inside the docker container,`n              current directory will be mounted inside of it."
    exit -1
}

if ($env:DOCKER_INTERACTIVE_ARGS) {
    $docker_run_interactive_args = $env:DOCKER_INTERACTIVE_ARGS
}

. docker-build/docker-project-build-settings.ps1
. docker-build/docker_build_module/docker-global-build-settings.ps1

Write-Host "command to execute:`n${final_cmd}"
Invoke-Expression ${final_cmd}
