FROM ubuntu:latest
MAINTAINER ELOUIZ BADR <elouiz.badr@gmail.com>

COPY percona_ubuntu-xenial_repo.deb ./

RUN dpkg -i percona_ubuntu-xenial_repo.deb && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nano percona-xtradb-cluster-57 \
 && rm -rf /var/lib/apt/lists/*

COPY percona_xtradb_cluster_config.sh ./

RUN service mysql stop && ./percona_xtradb_cluster_config.sh

EXPOSE 3306 4444 4567 4568

ENTRYPOINT ["/bin/bash"]
