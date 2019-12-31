# cectf-docker-build

This repository contains everything necessary to manage the cectf docker installation.
The individual components of cectf can all be installed and run independently (and indeed this is recommended for development environments), but for the production deployment ([https://ctf.chiquito.us]) we use docker to make managing and updating the environment easier.
I (Daniel) am using the repository to manage my cluster of Raspberry Pi's that are all running docker in a swarm configuration.

## Docker Compose

Management of the application environment is done through Docker compose files.
Because I'd rather not expose details about the implementation of my deployment for security reasons, these compose files are templatized.
Set the correct values in `nfs-env.sh` and run `./setup-compose.sh` to generate them.

## Private Registry

I rely on a private registry to host all of the Docker images once they are built.
The docker compose file `registry-compose.yml` can be used to quickly and easily bring up this registry:

`docker stack up -c registry-compose.yml registry`

The registry will now be available to any node in the swarm on `127.0.0.1:5000`. You can visit it at `http://10.11.12.13:5000/v2/_catalog` (replace with the IP of one of your nodes) to confirm that it is running and hosting images.

## Building the Docker Image

Simply run `./build.sh`. It will automatically detect if you are on a Raspberry Pi (which uses an ARM processor and therefore requires a different base image) or a traditional machine, generate an appropriate `Dockerfile`, build it, tag it, and attempt to upload it to the private registry. Once there, it will be available to every node.

## Staging/Production Environments

To bring up either the staging or production environments, simply log in to the swarm manager and do one of:

`docker stack up -c staging-compose.yml staging`

`docker stack up -c production-compose.yml production`

To take down the application, do `docker stack rm staging` or `docker stack rm production`

WARNING: If you are working on the NFS volume definitions, be warned that docker WILL NOT delete the old volumes from the nodes when bringing up a new stack.
For new changes to the volume definitions to take effect, you must manually delete them from each node by logging in and doing `docker volume rm {name_of_volume}`. 
