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
$image_name="some-docker-username"
$image_tag="master" # or "latest"
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

### Docker exec

You can also run Docker exec commands if there is already a running container like this:
```

# in one terminal do this:
./docker-run.ps1 bash

# in another terminal, do this:
./docker-exec.ps1 bash
```


# Examples for Espressif hardware

You can use this to target any kind of container for builds, but, it was originally built for building via Espressif-based containers 

# ESP32

place the following in your docker-build/docker-project-build-settings.ps1 for ESP-IDF builds (like for ESP32 chips)

```
$image_name="espressif/idf"
$image_tag="release-v4.3"
$container_mount_path = '/project'
```

Then you can build like this:
```
# do this once or as needed
./docker-pull.ps1

# run "make all" in the container
./docker-run.ps1 idf.py build
```

If you're on linux, you CAN use the USB subsystem to do idf.py flash or idf.py monitor, but, on WSL2 (like what Docker Desktop uses), these commands won't work under default Windows 10 settings (USB passthrough to docker containers doesn't work). Win11 is adding support for this though.  Until then you still have to flash outside of the container on Win10 + Docker Desktop. Bummer.

This USB passthrough is supposed to work on Win11 out of the gate though.

## Esp8266

for esp8266-based builds using CNlohr's version of esp-open-sdk place the following in your docker-build/docker-project-build-settings.ps1 for ESP-IDF builds (like for ESP32 chips)

```
$image_name="ghcr.io/unit-e/esp-open-sdk-docker"
$image_tag="cnlohr-use-esp82xx-prebuilt"
```

Then you can build like this:
```
# do this once or as needed
./docker-pull.ps1

# run "make all" in the container
./docker-run.ps1 make all
```
