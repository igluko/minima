# minima
Minima in docker

# Howto start (Ubuntu 22.04):

## 1. Install Docker and download compose file:
```
apt update && \
apt upgrade -y && \
apt install docker docker-compose jq git -y && \
curl https://raw.githubusercontent.com/igluko/minima/main/docker-compose.yml  -o docker-compose.yml && \
docker-compose pull
```

## 2. Change MiniDap password
Change to YOUR_PASSWORD
```
sed -i '/minima_mdspassword/ s/123/YOUR_PASSWORD/g'  docker-compose.yml
```
Check it
```
cat docker-compose.yml | grep minima_mdspassword
```

## 2. Start containers

Start 1 minima container (scale 1):
```
docker-compose up -d --scale minima=1
```

Start another 2 minima container (scale 3):
```
docker-compose up -d --scale minima=3
```
## 3 Get containers list
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


## 4 Incentivecash

### Start the Minima Terminal by running the command: 
```
docker exec -it root_minima_1 minima
```
```
Minima @ 26/12/2022 15:00:18 [3.3 MB] : **********************************************
Minima @ 26/12/2022 15:00:18 [3.7 MB] : *  __  __  ____  _  _  ____  __  __    __    *
Minima @ 26/12/2022 15:00:18 [3.7 MB] : * (  \/  )(_  _)( \( )(_  _)(  \/  )  /__\   *
Minima @ 26/12/2022 15:00:18 [3.7 MB] : *  )    (  _)(_  )  (  _)(_  )    (  /(__)\  *
Minima @ 26/12/2022 15:00:18 [3.7 MB] : * (_/\/\_)(____)(_)\_)(____)(_/\/\_)(__)(__) *
Minima @ 26/12/2022 15:00:18 [3.7 MB] : *                                            *
Minima @ 26/12/2022 15:00:18 [3.7 MB] : **********************************************
Minima @ 26/12/2022 15:00:18 [3.7 MB] : Welcome to the Minima RPCClient - for assistance type help. Then press enter.
Minima @ 26/12/2022 15:00:18 [3.7 MB] : To 'exit' this app use 'exit'. 'quit' will shutdown Minima
```
### Setup your Incentive Program account by connecting your Incentive ID (xxxxxxxxxxxxxxxxxx)
```
incentivecash uid:xxxxxxxxxxxxxxxxxx
```
### Check your Incentive Program balance
```
incentivecash
```


## MiniDap


```
docker ps --format '{{.Names}}' | xargs -I {} docker inspect {} --format '{{.Name}} {{.NetworkSettings.Networks.root_default.IPAddress}} {{(index (index .NetworkSettings.Ports "9003/tcp") 0).HostPort}}'
```
```
/root_minima_2 172.18.0.3 49217
/root_minima_1 172.18.0.2 49216
/root_minima_3 172.18.0.4 49215
```
To enter MiniDapp minima_1, you need to open the address: https://YourServerIP:49216 in your browser

# Howto update:
Just repeat steps 1-2

Warning. If you reduce the number of instances and then increase again, the new instances will have to be set up again!!!
