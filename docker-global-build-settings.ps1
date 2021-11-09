#!/usr/bin/env pwsh

# global build settings for any project using docker to build
# pass some variables pre-set in here to use this.

# if these aren't set from the commandline, set some default values.
# "-it" means interactive + TTY. good for running from the commandline, but will cause errors if run from CI.
# make sure to set this to be empty or just 't' if built from CI (like github)
IF(!$docker_run_interactive_args) {
    $docker_run_interactive_args = '-it'
}

# set any other params you like here from the commandline (by default nothing)
IF(!$docker_run_extra_args) {
    $docker_run_extra_args = ''
} else {

}

$container_ref="${container_name}:${container_branch}"

# deal with filenames with spaces in them [woof]
$PWD_escaped=${PWD} -replace ' ', '` '

$volume_mount="-v ${PWD_escaped}:/home/build/src"

$container_user_args=""     # "--user build"
$docker_args = "--rm ${container_user_args} ${docker_run_interactive_args} ${$docker_run_extra_args} ${volume_mount}"

# create these for use in calling scripts
$final_cmd = "docker run ${docker_args} ${container_ref} /bin/bash -c `"${container_command}`""
$pull_cmd = "docker pull ${container_ref}"