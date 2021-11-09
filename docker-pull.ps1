#!/usr/bin/env pwsh
#
# this is a powershell script for building this project via a docker container
# use like this: ./docker-run make clean
# should work on Windows, plus any *nix with powershell installed.
# 
# current dir is mounted into the container, command is executed inside the docker container there.
# afterwards, the container (not the image) is destroyed. so every command run is a fresh new container

. docker-build/docker-project-build-settings.ps1
. docker-build/docker_build_module/docker-global-build-settings.ps1

Write-Output "pull command to execute:`n${pull_cmd}"
Invoke-Expression ${pull_cmd}
