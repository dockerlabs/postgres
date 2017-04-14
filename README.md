#  PostgreSQL

[![Build Status](https://travis-ci.org/dockerlabs/postgres.svg?branch=master)](https://travis-ci.org/dockerlabs/postgres) [![Docker Automated buil](https://img.shields.io/docker/automated/mongkok/postgres.svg)](https://hub.docker.com/r/mongkok/postgres)

### Usage

**Database**

```sh
sudo docker run --name pg.master -i --rm \
    --network postgres \
    --env 'POSTGRES_PASSWORD=pass' \
    --env 'DB_NAME=mydb' \
    --env 'DB_USER=me' \
    --env 'REPLICATION_USER=replication-user' \
    --env 'REPLICATION_PASS=replication-pass' \
    mongkok/postgres
```

**Slave**

```sh
docker run --name pg.slave -i --rm \
    --network postgres \
    --env 'REPLICATION_MODE=slave' \
    --env 'REPLICATION_HOST=pg.master' \
    --env 'REPLICATION_PORT=5432' \
    --env 'REPLICATION_USER=replication-user' \
    --env 'REPLICATION_PASS=replication-pass'
    mongkok/postgres
```

**Snapshot**

```sh
docker run --name pg.snapshot -i --rm \
    --network postgres \
    --env 'REPLICATION_MODE=snapshot' \
    --env 'REPLICATION_HOST=pg.master' \
    --env 'REPLICATION_PORT=5432' \
    --env 'REPLICATION_USER=replication-user' \
    --env 'REPLICATION_PASS=replication-pass'
    mongkok/postgres
```

**Backup**

```sh
docker run --name pg.backup -i --rm \
    --network postgres \
    --env 'REPLICATION_MODE=backup' \
    --env 'REPLICATION_HOST=pg.master' \
    --env 'REPLICATION_PORT=5432' \
    --env 'REPLICATION_USER=replication-user' \
    --env 'REPLICATION_PASS=replication-pass' \
    --volume /path/to/backup:/var/lib/postgresql/replica \
    mongkok/postgres
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
