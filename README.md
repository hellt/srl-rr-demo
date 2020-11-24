# Container-based lab environments with containerlab
[Containerlab](https://containerlab.srlinux.dev) provides a framework to set up networking labs with containers.

With the following procedure we demonstrate how quick and easy it is to spin up a container-based lab which consists of two Nokia SR Linux nodes and a GoBGP container that constitutes a BGP Route-Reflection feature demonstration.

## Lab setup
The lab will be built with three components:

1. Nokia SR Linux node acting as a Route Reflector (lab node name `rr`)
2. Nokia SR Linux node acting as a Route Reflector client (lab node name `c1`)
3. GoBGP container acting as a route originator (lab node name `c2`)

<p align="center">
<img src="https://gitlab.com/rdodin/pics/-/wikis/uploads/37c03e42cbbc946fb955c885d25ee848/image.png" width=50%>
</p>

### Install containerlab

Installation is a breeze:

```
sudo curl -sL https://get-clab.srlinux.dev | sudo bash
```

### Get the demo files

```
git clone https://github.com/hellt/srl-rr-demo.git

cd srl-rr-demo
```

> Copy license.key file to the srl-rr-demo dir

### Deploy a lab

```
containerlab deploy -t rr-lab-v2.yml
```

### Configure & start GoBGP

GoBGP container doesn't have GoBGP daemon started. Start it and make a v4 announcement with the following command:

```
docker exec -it clab-rrdemo-c2 bash lab/gobgp.sh
```

## Validate results
At this point you should have your lab ready. Route Reflector node should have received an update from Client2 (c2 node) and reflected it to Client1(c1 node).
Validate this by issuing a CLI command on route reflector:

```
docker exec -it clab-rrdemo-rr sr_cli -c "show network-instance default protocols bgp neighbor"

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BGP neighbor summary for network-instance "default"
Flags: S static, D dynamic, L discovered by LLDP, B BFD enabled, - disabled, * slow
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+-------------------+----------------------------+-------------------+-------+----------+----------------+----------------+--------------+----------------------------+
|     Net-Inst      |            Peer            |       Group       | Flags | Peer-AS  |     State      |     Uptime     |   AFI/SAFI   |       [Rx/Active/Tx]       |
+===================+============================+===================+=======+==========+================+================+==============+============================+
| default           | 192.168.1.2                | iBGPv4            | S     | 42000000 | established    | 0d:0h:0m:4s    | ipv4-unicast | [1/1/0]                    |
|                   |                            |                   |       | 00       |                |                |              |                            |
| default           | 192.168.12.2               | iBGPv4            | S     | 42000000 | established    | 0d:0h:1m:27s   | ipv4-unicast | [0/0/1]                    |
|                   |                            |                   |       | 00       |                |                |              |                            |
+-------------------+----------------------------+-------------------+-------+----------+----------------+----------------+--------------+----------------------------+
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
```