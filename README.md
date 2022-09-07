
# Cyrus SASL Compilation (`cyrus-sasl-compilation`)

## Description

This repository provides tools to recompile `cyrus-sasl` packages (currently only `.deb` packages for Debian), in order to apply some specific and/or useful patches.

## Patches

| Identifier | Description | Related link(s) |
|------------|-------------|-----------------|
| 0100-password-length.patch | Increase password length from 256 to 4096 characters, useful if you want to pass tokens or anything longer than a regular password | https://github.com/cyrusimap/cyrus-sasl/pull/611 |

## Instructions

1. Build appropriate Docker image, using the Debian version of your choice (here: `buster`)
```bash
# ----- args -----
# VERSION - Debian version targeted
#
docker build -t cyrus-sasl-compil:buster -f dockerfiles/debian/Dockerfile --build-arg VERSION=buster .
```

2. Using the previously built image, run the package compilation, applying patches doing so
```bash
# ----- args -----
# DEB_PREFIX - Prefix that will be added to the package version name
# DEB_EMAIL - Email of the package builder/maintainer
# DEB_NAME - Full name of the package builder/maintainer
#
docker run --rm --name csc-deb-buster \
    -v "$PWD"/scripts:/scripts -v "$PWD"/output/debian/buster:/compil \
    --env DEB_PREFIX=ABC --env DEB_EMAIL=your.name@example.com --env DEB_NAME=YourName \
    cyrus-sasl-compil:buster /scripts/compil.sh
```

## Examples

### Example - Debian `buster`
```bash
docker build -t cyrus-sasl-compil:buster -f dockerfiles/debian/Dockerfile --build-arg VERSION=buster .

docker run --rm --name csc-deb-buster \
    -v "$PWD"/scripts:/scripts -v "$PWD"/output/debian/buster:/compil \
    --env DEB_PREFIX=ABC --env DEB_EMAIL=your.name@example.com --env DEB_NAME=YourName \
    cyrus-sasl-compil:buster /scripts/compil.sh
```

### Example - Debian `stretch`
```bash
docker build -t cyrus-sasl-compil:stretch -f dockerfiles/debian/Dockerfile --build-arg VERSION=stretch .

docker run --rm --name csc-deb-stretch \
    -v "$PWD"/scripts:/scripts -v "$PWD"/output/debian/stretch:/compil \
    --env DEB_PREFIX=ABC --env DEB_EMAIL=your.name@example.com --env DEB_NAME=YourName \
    cyrus-sasl-compil:stretch /scripts/compil.sh
```

## Contributors

- **Grégoire GUTTIN** - Original scripts and patch
- **Tom-Brian GARCIA** - Reformatting (and translating) tasks for Github publication