#!/usr/bin/env pwsh
# example: ./docker.ps1 run bash

# optional, pick another profile for different container/etc
$Env:DPROFILE = 'default'

# calls the script in the submodule to do all the hard work
./docker-build/docker_build_module/docker.ps1 "$args"