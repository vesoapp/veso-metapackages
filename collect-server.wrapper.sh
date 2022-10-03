#!/usr/bin/env bash

# Veso Azure builds collection wrapper script
# Because Azure is a fail

nohup /srv/jellyfin/projects/server/veso-metapackages/collect-server.sh $1 $2 $3 & disown
