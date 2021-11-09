# Docker bootstrap scripts
There's probably better ways, but, this is for using Docker to run build toolchains inside a docker container.

# Instructions

1. Clone this repository as a submodule [or just copy the files] and place it in this folder in your repo:
```.\docker-build\docker_build_module```

2. create a file named docker-build/docker-project-build-settings.ps1 with the following stuff in it:

```
#!/usr/bin/env pwsh
#
# project-specific variables for use with building via docker container

# change these for your particular project
$container_name="some-docker-username"
$container_branch="master" # or "latest"
```

3. Make a copy of files in ```.\docker-build\docker_build_module\copy_into_client\*``` to your project root.

# Usage

Your local project directory will be mounted inside the container at /home/build/src/, which is also the working directory

Run commands in the container like this:

```
# pull the container
./docker-pull.ps1

# run commands in the container like:
./docker-run.ps1 make all
./docker-run.ps1 find -name *.c

# or, log into the container and run commands there:
./docker-run.ps1 bash
user@container: ls -alltr
user@container: make all
```

To run in CI systems, specify DOCKER_INTERACTIVE_ARGS="-t" to disable interactive mode, like this:

```
./docker-run.ps1 DOCKER_INTERACTIVE_ARGS="-t" make all
```