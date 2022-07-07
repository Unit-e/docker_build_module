#!/usr/bin/env pwsh
#
# this is a powershell script for running commands via 'docker exec' via an already running docker container
# use something like this: ./docker-exec make clean
# should work on Windows, plus any *nix with powershell installed.

$container_command=$args

If (!$container_command) {
    $prog_name="./docker-exec.ps1" # there's way better methods than this in powershell. fix
    Write-Host "usage:      ${prog_name} <command>`n`n"
    Write-Host "example:    ${prog_name} make clean && make clean && ls /tmp`n            ^ runs these commands inside the docker container,`n              current directory will be mounted inside of it."
    exit -1
}

if ($env:DOCKER_INTERACTIVE_ARGS) {
    $docker_run_interactive_args = $env:DOCKER_INTERACTIVE_ARGS
}

. docker-build/docker-project-build-settings.ps1
. docker-build/docker_build_module/docker-global-build-settings.ps1

Write-Host "command to execute:`n${docker_exec_cmd}"
Invoke-Expression ${docker_exec_cmd}
