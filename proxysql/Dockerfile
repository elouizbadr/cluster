FROM ubuntu:latest
MAINTAINER ELOUIZ BADR <elouiz.badr@gmail.com>

COPY percona_ubuntu-xenial_repo.deb ./

RUN dpkg -i percona_ubuntu-xenial_repo.deb && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nano percona-server-client proxysql \
 && rm -rf /var/lib/apt/lists/*

RUN service proxysql stop

EXPOSE 3306 6032

ENTRYPOINT ["/bin/bash"]
