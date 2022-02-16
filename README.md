# minima
Minima in docker

# Howto start (Ubuntu 20.04):

Build:
```
apt update && \
apt upgrade -y && \
apt install docker docker-compose jq curl -y && \
curl https://raw.githubusercontent.com/igluko/minima/main/Dockerfile > Dockerfile && \
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
```

```
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                            PORTS           NAMES
4b656095eac4   minima         "/bin/sh -c 'java -X…"   3 seconds ago    Up 1 second                       9001-9002/tcp   silly_haslett
fbf00e8b6ecb   minima         "/bin/sh -c 'java -X…"   4 seconds ago    Up 3 seconds                      9001-9002/tcp   sad_fermat
```

Get IP by id:
```
docker inspect 4b656095eac4 | jq .[].NetworkSettings.Networks.bridge.IPAddress
```
>"172.17.0.3"

Get IP by name:
```
docker inspect silly_haslett | jq .[].NetworkSettings.Networks.bridge.IPAddress
```
>"172.17.0.3"

Login in account Incentivecash and copy ID node to your container: 
```
curl 172.17.0.3:9002/incentivecash+uid:ID_your_node | jq
```
It must return "true"

Return to the Incentivecash and will be able to see ping.
Done.

# Howto update:
Remove all containers:
```
docker kill $(docker ps -q);  \
docker rm $(docker ps -a -q); \
docker rmi $(docker images -q)
```
Then use Howto start (Ubuntu 20.04) steps.
