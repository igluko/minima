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
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS                            PORTS     NAMES
5cb8cb68f092   minima    "/bin/sh -c '/usr/bi…"   3 minutes ago   Restarting (127) 52 seconds ago             laughing_grothendieck
```

Get IP by id
```
docker inspect 5cb8cb68f092 | jq .[].NetworkSettings.Networks.bridge.IPAddress

```

Get IP by name
```
docker inspect laughing_grothendieck | jq .[].NetworkSettings.Networks.bridge.IPAddress
```
