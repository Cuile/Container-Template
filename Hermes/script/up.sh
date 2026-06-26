#!/bin/bash
 
podman-compose --env-file ../container/.env \
               -f ../container/start.yaml \
               up -d
