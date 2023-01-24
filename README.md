# minima
Minima in docker

## Howto start (Ubuntu 22.04):

```
wget -N https://raw.githubusercontent.com/igluko/minima/main/minima && chmod +x minima && ./minima && source ~/.bashrc
```

## Change password or number of containers

```
minima
```
## Check status
```
minima status
```

## Backup
```
minima backup
```

## Incentivecash

### Connect to 1-st conteiner:
```
minima 1
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

# Restart containers

```
minima restart
```

# Remove containers
```
docker-compose down; \
docker kill $(docker ps -q);  \
docker rm $(docker ps -a -q); \
docker rmi $(docker images -q); \
docker volume prune -f
```
