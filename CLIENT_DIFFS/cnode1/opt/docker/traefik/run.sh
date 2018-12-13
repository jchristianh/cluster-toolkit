#!/bin/bash
docker run -d --name traefik --hostname traefik -p 8080:8080 -p 80:80 -v $PWD/traefik.toml:/etc/traefik/traefik.toml traefik
