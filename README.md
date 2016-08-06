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

