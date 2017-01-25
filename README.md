# docker-ts3server

[![](https://images.microbadger.com/badges/image/galexrt/ts3server.svg)](https://microbadger.com/images/galexrt/ts3server "Get your own image badge on microbadger.com")

[![Docker Repository on Quay](https://quay.io/repository/galexrt/ts3server/status "Docker Repository on Quay")](https://quay.io/repository/galexrt/ts3server)

Image available from:
* [**Quay.io**](https://quay.io/repository/galexrt/ts3server)
* [**Docker Hub**](https://hub.docker.com/r/galexrt/ts3server)

TS3Server in a Docker Image

## Usage
### Pulling the image
From quay.io:
```
docker pull quay.io/galexrt/ts3server:latest
```
Or from Docker Hub:
```
docker pull galexrt/ts3server:latest
```

### Running the TS3Server
```
docker run \
    -d \
    --name=ts3server \
    -v /opt/docker/ts3server:/data \
    quay.io/galexrt/ts3server:latest
```

### Manually specify TS3Server version
Add the following env variable to the docker run command:
```
TS_VERSION=3.1.0.1
```

### SELinux
Add the `z` option behind the volume mount:
```
docker run \
    -d \
    --name=ts3server \
    -v /opt/docker/ts3server:/data:z \
    quay.io/galexrt/ts3server:latest
```
