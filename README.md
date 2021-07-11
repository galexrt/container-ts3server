# docker-ts3server

[![Docker Repository on Quay](https://quay.io/repository/galexrt/ts3server/status "Docker Repository on Quay")](https://quay.io/repository/galexrt/ts3server)

Image available from:

* [**Quay.io**](https://quay.io/repository/galexrt/ts3server)

TS3Server in a Docker Image

## Usage

### Pulling the image

From quay.io:

```shell
docker pull quay.io/galexrt/ts3server:latest
```

### Running the TS3Server

```shell
docker run \
    -d \
    --name=ts3server \
    -v /opt/docker/ts3server:/data \
    quay.io/galexrt/ts3server:latest
```

### Manually specify TS3Server version

Add the following env variable to the docker run command:

```shell
TS_VERSION=3.13.6
```

### Data Volume

Data directory needs to be owned by UID and GID `3000`.

### SELinux

Add the `z` option behind the volume mount:

```shell
docker run \
    -d \
    --name=ts3server \
    -v /opt/docker/ts3server:/data:z \
    quay.io/galexrt/ts3server:latest
```
