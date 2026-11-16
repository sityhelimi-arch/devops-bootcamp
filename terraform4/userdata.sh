#!/bin/bash
set -euxo pipefail

apt-get update -y
apt-get install -y docker.io docker-compose-v2 curl
systemctl start docker
systemctl enable docker

until docker info >/dev/null 2>&1; do
  sleep 2
done

mkdir -p /opt/rackula/data
curl -fsSL https://raw.githubusercontent.com/RackulaLives/Rackula/main/deploy/docker-compose.persist.yml -o /opt/rackula/docker-compose.yml
chown -R 1001:1001 /opt/rackula/data

cd /opt/rackula
docker compose up -d
