#!/bin/bash

ipaddr=

for machine in nomad-node-{2,3}; do
  vagrant ssh $machine -c 'env NOMAD_ADDR=$(ip -o route get 192.168.50.0/24 | awk "{print $7;exit}") nomad server-join nomad-node-1'
done
