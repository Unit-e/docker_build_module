#!/usr/bin/env pwsh

# global build settings for any project using docker to build
# pass some variables pre-set in here to use this.

# if these aren't set from the commandline, set some default values.
# "-it" means interactive + TTY. good for running from the commandline, but will cause errors if run from CI.
# make sure to set this to be empty or just 't' if built from CI (like github)
IF(!$docker_run_interactive_args) {
    $docker_run_interactive_args = '-it'
}

IF(!$docker_rm_args) {
    $docker_rm_args = '--rm'
}

# set any other params you like here from the commandline (by default nothing)
IF(!$docker_run_extra_args) {
    $docker_run_extra_args = ''
}

# set any other params you like here from the commandline (by default nothing)
IF(!$container_mount_path) {
    $container_mount_path = '/home/build/src'
}

IF(!$image_name_and_tag) {
    $image_name_and_tag = "${image_name}:${image_tag}"
}

# if running this command FROM powershell in a directory that starts with \\wsl$\, we get a weird
# path output prepended with due to Powershell's pipline binding stuff.  remove it.
# example path input: "Microsoft.PowerShell.Core\FileSystem::\\wsl$\Ubuntu-20.04\path\to\repo"
# this command gives us back: "\\wsl$\Ubuntu-20.04\path\to\repo"
$converted_pwd = Convert-Path -Path $pwd

# deal with filenames with spaces in them [woof]
$PWD_escaped=${converted_pwd} -replace ' ', '` '

IF(!$volume_mount) {
    $volume_mount="-v ${PWD_escaped}:${container_mount_path}"
}

IF(!$working_dir) {
    $working_dir="-w ${container_mount_path}"
}

if ($container_name) {
    $container_name_args = "--name ${container_name}"
}

if (!$docker_exec_entrypoint_exe)
{
    $docker_exec_entrypoint_exe=''
}

$container_user_args=""     # example: "--user build"
$docker_run_args = "${docker_rm_args} ${container_user_args} ${docker_run_interactive_args} ${container_name_args} ${docker_run_extra_args} ${volume_mount} ${working_dir}"

# generate these variables. calling scripts can use them to execute stuff
$docker_run_cmd = "docker run ${docker_run_args} ${image_name_and_tag} /bin/bash -c `"${container_command}`""
$docker_exec_cmd = "docker exec $docker_run_interactive_args ${container_name} ${docker_exec_entrypoint_exe} ${container_command}"
$docker_pull_cmd = "docker pull ${image_name_and_tag}"