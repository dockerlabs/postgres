# PostgreSQL

[![Build Status](https://travis-ci.org/dockerlabs/postgres.svg?branch=master)](https://travis-ci.org/dockerlabs/postgres) [![Docker Automated buil](https://img.shields.io/docker/automated/mongkok/postgres.svg)](https://hub.docker.com/r/mongkok/postgres)

### Quickstart

Start PostgreSQL creating database user:

```sh
sudo docker run --name pg.master -itd --restart always \
    --env 'POSTGRES_PASSWORD=pass' \
    --env 'POSTGRES_DB_NAME=mydb' \
    --env 'POSTGRES_DB_USER=me' \
    --env 'POSTGRES_DB_PASS=db-pass' \
    --env 'POSTGRES_DB_EXTENSION=postgis,hstore,uuid-ossp' \
    mongkok/postgres:9.6
```



### Creating replication user

```sh
sudo docker run --name pg.master -itd --restart always \
    --env 'REPLICATION_USER=replication-user' \
    --env 'REPLICATION_PASS=replication-pass' \
    mongkok/postgres:9.6
```


### Setting up a replication cluster

```sh
docker run --name pg.slave -itd --restart always \
    --network postgres \
    --env 'REPLICATION_MODE=slave' \
    --env 'REPLICATION_HOST=pg.master' \
    --env 'REPLICATION_PORT=5432' \
    --env 'REPLICATION_USER=replication-user' \
    --env 'REPLICATION_PASS=replication-pass' \
    mongkok/postgres:9.6
```

### Creating a snapshot

```sh
docker run --name pg.snapshot -itd --restart always \
    --network postgres \
    --env 'REPLICATION_MODE=snapshot' \
    --env 'REPLICATION_HOST=pg.master' \
    --env 'REPLICATION_PORT=5432' \
    --env 'REPLICATION_USER=replication-user' \
    --env 'REPLICATION_PASS=replication-pass' \
    mongkok/postgres:9.6
```

### Creating a backup

```sh
docker run --name pg.backup -it --rm \
    --network postgres \
    --env 'REPLICATION_MODE=backup' \
    --env 'REPLICATION_HOST=pg.master' \
    --env 'REPLICATION_PORT=5432' \
    --env 'REPLICATION_USER=replication-user' \
    --env 'REPLICATION_PASS=replication-pass' \
    --volume /path/to/postgresql.$(date +%Y%m%d%H%M%S):/var/lib/postgresql/replica \
    mongkok/postgres:9.6
```

### Inspiration

* **Oficial PostgreSQL**
    - Hub: [https://hub.docker.com/_/postgres/](https://hub.docker.com/_/postgres/)
    - Github: [docker-library/postgres](https://github.com/docker-library/postgres)

* **PostGIS**
    - Hub: [https://hub.docker.com/r/mdillon/postgis/](https://hub.docker.com/r/mdillon/postgis/)
    - Github: [appropriate/docker-postgis](https://github.com/appropriate/docker-postgis)

* **Replications** 
    - Hub: [https://hub.docker.com/r/sameersbn/postgresq](https://hub.docker.com/r/sameersbn/postgresq)
    - Github: [sameersbn/docker-postgresql](https://github.com/sameersbn/docker-postgresql)
