#!/bin/bash
# configure c2 IP address
bash /lab/ipaddr.sh
# start gobgpd daemon
gobgpd -t /lab/yaml -f /lab/gobgp.yml &
sleep 5

# make ipv4 BGP announcement
bash /lab/v4-announce.sh