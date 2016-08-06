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

## Build:
  * `docker build --no-cache -t`

## Run:
  * `rancher-compose --verbose -f rancher-compose.yml -p rancher-status up --upgrade --confirm-upgrade --pull -d`

## Hit it from the Demandbase Office VPN:
`rancher-dev.demandbase.com`
`rancher-staging.demandbase.com`
`rancher-prod.demandbase.com`

