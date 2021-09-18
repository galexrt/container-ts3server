# docker-ts3server

Container Image with TeamSpeak³ Server.

Container Image available from:

* [Quay.io](https://quay.io/repository/galexrt/ts3server)

Container Image Tags:

* `main` - Latest build of the `main` branch.
* `vx.y.z` - Latest build of the application (updated in-sync with the date container image tags).
* `vx.y.z-YYYYmmdd-HHMMSS-NNN` - Latest build of the application with date of the build.

## Usage

### Pulling the image

From quay.io:

```shell
docker pull quay.io/galexrt/ts3server:main
```

### Running the TS3Server

```shell
docker run \
    -d \
    --name=ts3server \
    -v /opt/docker/ts3server:/data \
    quay.io/galexrt/ts3server:main
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
    quay.io/galexrt/ts3server:main
```
