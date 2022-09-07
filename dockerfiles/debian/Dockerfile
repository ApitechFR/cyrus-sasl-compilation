#####
# name: cyrus-sasl-compilation
# description: Utility image to rebuild cyrus-sasl debian package
# authors: Grégoire GUTTIN, Tom-Brian GARCIA
#####

# Allows FROM instruction to use VERSION
ARG VERSION

# Use the version provided by the build command
FROM debian:${VERSION}

# Allows other instructions to use VERSION
ARG VERSION

# Update apt sources
RUN echo "deb http://deb.debian.org/debian/ $VERSION main contrib non-free" > /etc/apt/sources.list
RUN echo "deb-src http://deb.debian.org/debian/ $VERSION main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian/ $VERSION-updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.debian.org/debian/ $VERSION-updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian-security $VERSION/updates main" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.debian.org/debian-security $VERSION/updates main" >> /etc/apt/sources.list

# Install required tools
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install devscripts build-essential lintian
RUN mkdir source && cd source
RUN apt-get source sasl2-bin
RUN apt-get -y build-dep sasl2-bin