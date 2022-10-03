# Veso Metapackages

This repository contains the various Veso metapackage definitions. With the build split for the 10.6.0 release, the [main server](https://github.com/vesoapp/veso) and [web client](https://github.com/vesoapp/veso-web) are built separately, in order to ensure that both of them are unique and there is no built-time cross dependencies between the two repositories. This simplifies building for releases, as well as enables per-PR "unstable" builds as opposed to timed "daily" builds.

## Debian

This is a simple `equivs-build` definition which will build a Debian metapackage for the [`veso-server`](https://github.com/vesoapp/veso) and [`veso-web`](https://github.com/vesoapp/veso-web) `.deb` files. By design, there is no restrictions on the version of the dependency packages; this ensure that this metapackage will always install the latest version of these two packages and simplifies the management of this file, especially for the per-PR "unstable" builds.

The version indicator in this file is the invalid placeholder `X.Y.Z`. This must be replaced with a real version at build time, e.g. with `sed -i 's/X.Y.Z/10.6.0/g' jellyfin.debian`.

The package is built with the following command: `equivs-build jellyfin.debian`.

## Docker

This is a simple set of Docker images that combine the [`veso-server`](https://github.com/vesoapp/veso) and [`veso-web`](https://github.com/vesoapp/veso-web) Docker images into one final `jellyfin` image for distribution. They are built in response to the main CI when the per-repository builds are completed.

Changes to the Docker dependencies at runtime should go here; only build-specific changes should go in the main repositories.

There is no version indicator in these Dockerfiles; this is only relevant in the naming when run from CI.

The Dockerfiles are built with the following commands. This will be done through CI, either on our build server or Azure:

#### Stable

```
docker build -t veso:{version}-{arch} --build-arg TARGET_RELEASE=stable -f Dockerfile.{arch} .
docker manifest create --amend veso:{version} \
    veso:{version}-amd64 \
    veso:{version}-arm64 \
    veso:{version}-armhf
docker manifest push --purge veso:{version}
docker manifest create --amend veso:latest \
    veso:{version}-amd64 \
    veso:{version}-arm64 \
    veso:{version}-armhf
docker manifest push --purge veso:latest
```

#### Unstable

```
docker build -t veso:{build_id}-{arch} --build-arg TARGET_RELEASE=unstable -f Dockerfile.{arch} .
docker manifest create --amend veso:unstable-{build_id} \
    veso:{version}-amd64 \
    veso:{version}-arm64 \
    veso:{version}-armhf
docker manifest push --purge veso:unstable-{version}
docker manifest create --amend veso:unstable \
    veso:{version}-amd64 \
    veso:{version}-arm64 \
    veso:{version}-armhf
docker manifest push --purge veso:unstable
```
