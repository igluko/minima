# minima
Minima in docker

Howto (Ubuntu 20.04):

Build
```
apt update
apt upgrade -y
apt install docker docker-compose
wget https://raw.githubusercontent.com/igluko/minima/main/Dockerfile
docker build . -t minima
```

Start one:
```
docker run -d --restart unless-stopped minima
```

Start another:
```
docker run -d --restart unless-stopped minima
```

Get containers list:
```
docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                            PORTS           NAMES
4b656095eac4   minima         "/bin/sh -c 'java -X…"   3 seconds ago    Up 1 second                       9001-9002/tcp   silly_haslett
fbf00e8b6ecb   minima         "/bin/sh -c 'java -X…"   4 seconds ago    Up 3 seconds                      9001-9002/tcp   sad_fermat
```

Get IP by id
```
docker inspect 4b656095eac4 | jq .[].NetworkSettings.Networks.bridge.IPAddress
"172.17.0.3"
```

Get IP by name
```
docker inspect sad_fermat | jq .[].NetworkSettings.Networks.bridge.IPAddress
"172.17.0.4"
```
Login in account Incentivecash and copy IP node to your container: 
```
curl 127.0.0.1:9002/incentivecash+uid:ID_your_node | jq
```
It must return "true"

Return to the Incentivecash and you mast see ping to your node.
Done.
