# minima
Minima in docker

# Howto start (Ubuntu 22.04):

Install Docker and download compose file:
```
apt update && \
apt upgrade -y && \
apt install docker docker-compose jq git -y && \
curl https://raw.githubusercontent.com/igluko/minima/main/docker-compose.yml  -o docker-compose.yml

```

Start 1 minima container (scale 1):
```
docker-compose up -d --scale minima=1
```

Start another 2 minima container (scale 3):
```
docker-compose up -d --scale minima=3
```

Get containers list:
```
docker-compose ps -a
```

```
 Name                   Command               State                                    Ports
---------------------------------------------------------------------------------------------------------------------------------
root_minima_1   java -jar minima/minima.ja ...   Up      9001/tcp, 9002/tcp, 0.0.0.0:49216->9003/tcp,:::49216->9003/tcp, 9004/tcp
root_minima_2   java -jar minima/minima.ja ...   Up      9001/tcp, 9002/tcp, 0.0.0.0:49217->9003/tcp,:::49217->9003/tcp, 9004/tcp
root_minima_3   java -jar minima/minima.ja ...   Up      9001/tcp, 9002/tcp, 0.0.0.0:49215->9003/tcp,:::49215->9003/tcp, 9004/tcp
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

Get port to MiniDap
```
docker ps --format '{{.Names}}' | xargs -I {} docker inspect {} --format '{{.Name}} {{.NetworkSettings.Networks.root_default.IPAddress}} {{(index (index .NetworkSettings.Ports "9003/tcp") 0).HostPort}}'
```
```
/root_minima_2 172.18.0.3 49217
/root_minima_1 172.18.0.2 49216
/root_minima_3 172.18.0.4 49215
```

# Howto update:
Remove all containers:
```
docker kill $(docker ps -q);  \
docker rm $(docker ps -a -q); \
docker rmi $(docker images -q)
```
Then use Howto start (Ubuntu 20.04) steps.
