# Rancher-Status-Page:

* The purpose of this repo is to house a container that display the current status of a given rancher environment.
* This is important, because it allows to get a high-level view of currently deployed docker tags for each respective stack.

## Notes:
  * This job requires that the container runs in a Rancher environment in order to access the Rancher-Metadata API.
  * Containers that wish to use the status page must implement the `stack.name` label in their rancher-compose:

    ```
      labels:
        io.rancher.container.dns: "true"
        io.rancher.stack.name: "demandbase/rancher_status_page:${DOCKER_TAG}"
    ```

  * To use the rancher-metadata API, you must enable the following label in your container's rancher-compose file:

    ```
      io.rancher.container.dns: true
    ```

## Build:
  * `docker build --no-cache -t rancher-status-page`

## Run:
  * `docker-compose -f docker-compose.yml  up -d web`
  * `rancher-compose --verbose -f rancher-compose.yml -p rancher-status up --upgrade --confirm-upgrade --pull -d`

## Hit it from the Demandbase Office VPN:

http://rancher-dev.demandbase.com/

http://rancher-staging.demandbase.com/

http://rancher-prod.demandbase.com/

----

## Developing / Adding to rancher-status-page locally:
  * Run these in order (links for reference below):

    http://docs.rancher.com/os/running-rancheros/workstation/docker-machine/
    http://docs.rancher.com/rancher/v1.2/en/installing-rancher/installing-server/):

    * `docker-machine create -d virtualbox --virtualbox-boot2docker-url rancheros.iso rancher-server` 

        * `docker-machine ssh rancher-server`

        * `sudo docker run -d --restart=always -p 8080:8080 rancher/server`
          rancher-server VM's IP off its eth0 network interface.

    * `docker-machine create -d virtualbox --virtualbox-boot2docker-url rancheros.iso rancher-client`

        * `docker-machine ssh rancher-client`

    * After the container starts, setup port-forwarding on 8080 through your VM-provider for your rancher-server machine, and add a host to your rancher-setup
      by running the rancher-agent container on your rancher-client machine.  Be sure to use the IP bound to your eth0 interface in your rancher-server VM.

    * Create API keys (http://docs.rancher.com/rancher/v1.2/en/api/api-keys/).
   
    * Run your rancher-status-page container by populating the `rancher_env.sh` script in this repository with your new API keys and RANCHER URl settings from API->Add Environment API Key,
      and running the rancher-compose command after sourcing the script's environment:

      * `source rancher_env.sh` 
      * Be sure to set DOCKER_TAG to latest:
        
        `export DOCKER_TAG=latest`

      * `rancher-compose --verbose -f rancher-compose.yml -p rancher-status up --upgrade --confirm-upgrade --pull -d`
