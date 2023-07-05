# Base Image

All ai-dock images are extended from this base image.

This file should form the basis for the README.md for all extended images, with nothing but this introduction removed and additional features documented as required.

## Run Locally

A 'feature-complete' docker-compose.yaml file is included for your convenience. All features of the image are included - Simply edit the environment variables, save and then type `docker compose up`.

## Run in the Cloud

The image is compatible with any GPU cloud platform. You simply need to pass environment variables at runtime.

## Environment Variables

| Variable            | Description |
| ------------------- | ----------- |
| GPU_COUNT           | Limit the number of available GPUs |
| SSH_PUBKEY          | Your public key for SSH |
| RCLONE_*            | Rclone configuration - See [rclone documentation](https://rclone.org/docs/#config-file) |


## Volumes

Data inside docker containers is ephemeral - You'll lose all of it when the container is destroyed.

You may opt to mount a data volume at `/workspace` - This is a directory that ai-dock images will look for to make downloaded data available outside of the container for persistence. 

This is usually of importance where large files are downloaded at runtime.  Any image that makes use of this directory should replace this paragraph and document how and why /workspace is being utilised.

The provided docker-compose.yaml will mount the local directory `./workspace` at `/workspace`.

## Running Services

This image will start multiple processes on starting a container. All processes are managed by supervisord so will restart upon failure until you stop the container.

### SSHD

A SSH server will be started if at least one valid public key is found inside the running container in the file `/root/.ssh/authorized_keys`

There are several ways to get your keys to the container.

- If using docker compose, you can paste your key in the local file `config/authorized_keys` before starting the container.
 
- You can pass the environment variable `SSH_PUBKEY` with your public key as the value.

- Cloud providers often have a built-in method to transfer your key into the container

If you choose not to provide a public key then the SSH server will not be started.

To make use of this service you should map port 22 to a port of your choice on the host operating system.

### Rclone mount

Any Rclone remotes that you have specified, either through mounting the config directory or via setting environment variables will be mounted at `/mnt/[remote name]`. For this service to start, the following conditions must be met:

- Fuse3 installed in the host operating system
- Kernel module `fuse` loaded in the host
- Host `/etc/passwd` mounted in the container
- Host `/etc/group` mounted in the container
- Host device `/dev/fuse` made available to the container
- Container must run with cap-add SYS_ADMIN
- Container must run with securiry-opt apparmor:unconfined
- At least one remote must be configured

The provided docker-compose.yaml includes a working configuration (add your own remotes).

In the event that the conditions listed cannot be met, `rclone` will still be abailable to use via the CLI - only mounts will be unavailable.

If you intend to use the `rclone create' command to interactively generate remote configurations you should ensure port 53682 is mapped to the host operating system see https://rclone.org/remote_setup/ for further details.

### Logtail

This script follows and prints the log files for each of the above services to stdout. This allows you to follow the progress of all running services through docker's own logging system.

If you are logged into the container you can follow the logs by running `logtail.sh`

## Open Ports

Some ports need to be exposed for the services to run or for certain features of the provided software to function




