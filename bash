#!/bin/bash

git pull
docker compose up -d
docker exec -it  projet-php7.4-apache bash