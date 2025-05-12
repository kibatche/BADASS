#!/bin/bash

docker build -t router_mboivin .
docker build -t router_chbadad .
docker build -t leaf_chbadad .
docker build -t route_reflector_chbadad .
docker pull alpine:latest