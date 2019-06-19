#!/bin/bash

IMAGE=foldingathome
DOCKER=nvidia-docker
NETOPTS='--net host'

command -v $DOCKER || {
  echo "cannot find $DOCKER"
  exit 1
}

MOUNTS=''
ARGS=''
for ARG in $@; do
  [ -f $ARG ] && {
    FULLNAME=$(readlink -e $ARG)
    NAME=$(basename $ARG)
    MOUNTS="$MOUNTS -v $FULLNAME:/$IMAGE/$NAME:ro"
    ARGS="$ARGS /$IMAGE/$NAME"
  } || {
    ARGS="$ARGS $ARG"
  }
done

echo $DOCKER run --rm --user $(id -u):$(id -g) $NETOPTS $MOUNTS $IMAGE $ARGS
