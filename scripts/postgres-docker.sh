#!/bin/bash

mkdir -p postgres
cd postgres

docker pull postgres
docker pull dpage/pgadmin4:latest

docker volume create --driver local --name=pgvolume
docker volume create --driver local --name=pga4volume

docker network create --driver bridge pgnetwork

cat << EOF > pg-env.list
PG_MODE=primary
PG_PRIMARY_USER=postgres
PG_PRIMARY_PASSWORD=postgres
PG_DATABASE=vgsales
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin
PG_ROOT_PASSWORD=root
PG_PRIMARY_PORT=5432
EOF

cat << EOF > pgadmin-env.list
PGADMIN_DEFAULT_EMAIL=admin@domain.com
PGADMIN_DEFAULT_PASSWORD=admin
SERVER_PORT=5050
EOF

docker run --publish 5432:5432 \
    --volume=pgvolume:/pgdata \
    --env-file=pg-env.list \
    --name="postgres" \
    --hostname="postgres" \
    --network="pgnetwork" \
    --detach \
postgres:latest

docker run --publish 5050:80 \
    --volume=pga4volume:/var/lib/pgadmin \
    --volume=$PWD/../dataset:/dataset \
    --env-file=pgadmin-env.list \
    --name="pgadmin4" \
    --hostname="pgadmin4" \
    --network="pgnetwork" \
    --detach \
dpage/pgadmin4:latest