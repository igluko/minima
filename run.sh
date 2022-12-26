#!/bin/bash

###
# This script prepares a new PVE node
# Tested on Hetzner AX-101 servers
###

# Helpful to read output when debugging
# set -x

#https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# Strict mode
# set -eEuo pipefail
set -eEu
trap 'printf "${RED}Failed on line: $LINENO at command:${NC}\n$BASH_COMMAND\nexit $?\n"' ERR
# IFS=$'\n\t'

# read envivoments
source  /etc/environment
# get real path to script
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
# add binary folders to local path
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Read variable from file
function load {
    local FILE="${1}"
    if [[ -f  "${FILE}" ]]
    then 
        source "${FILE}"
    else
        touch "${FILE}"
    fi
}

# Save variable to file
function save {
    local VARIABLE="${1}"
    local VALUE="$(echo ${!1} | xargs)"
    local FILE="${2}"

    if grep -q ^${VARIABLE}= $FILE 2>/dev/null
    then
        eval "sed -i -E 's/${VARIABLE}=.*/${VARIABLE}=\"${VALUE}\"/' $FILE"
    else
        echo "${VARIABLE}=\"${VALUE}\"" >> $FILE
    fi
}

# Update variable in file from stdin
function update {
    local VARIABLE="${1}"
    if [[ $# -eq 2 ]]
    then
        local FILE="${2}"
    else
        local FILE="${SCRIPTPATH}/.env"
    fi

    load ${FILE}

    if [[ ! -v ${VARIABLE} ]];
    then
        eval ${VARIABLE}=""
    fi
    local VALUE="$(echo ${!1} | xargs)"

    printf "\n${RED}Please input ${VARIABLE}${NC}\n"
    read -e -p "> " -i "${VALUE}" ${VARIABLE}
    save ${VARIABLE} ${FILE}
    # echo "$VARIABLE is $VALUE"
}

function apt-install {
    for NAME in $*
    do
        local DPKG="dpkg -l | awk '\$2==\"${NAME}\" && \$1==\"ii\" {print \$1,\$2,\$3}'"
        if ! eval "${DPKG} | grep -q ii"
        then
            eval "apt update -y || true"
            eval "apt install -y ${NAME}"
        fi
        # Проверяем результат
        eval "${DPKG}"
    done
}

#-----------------------START-----------------------#

if [[ $# -eq 0 ]]
then
    # Ставим пакеты
    apt-install docker docker-compose jq git

    # Скачиваем compose файл
    wget -N https://raw.githubusercontent.com/igluko/minima/main/docker-compose.yml

    # Обновляем docker images
    docker-compose pull

    # Получаем общее количество памяти на хосте
    MEM_TOTAL=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')

    # Загружаем файл с настройками
    load ${SCRIPTPATH}/.env

    # Задаем количество инстансов
    if ! [[ -v INSTANCE_NUMBER ]]
    then
        # Задаем 1 инстанс, если переменная пустая
        INSTANCE_NUMBER="1"
    fi
    update INSTANCE_NUMBER

    # Задаем пароль
    if ! [[ -v MDS_PASSWORD ]]
    then
        # Генерируем пароль, если старого пароля нет
        MDS_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 20 ; echo '')
    fi
    update MDS_PASSWORD

    # Меняем ограничение памяти
    MEM=$((${MEM_TOTAL} / ${INSTANCE_NUMBER}))
    FILE="docker-compose.yml"
    eval "sed -i '/mem_limit/ s/:.*/: ${MEM}k/g' ${FILE}"
    # Меняем MDS пароль
    eval "sed -i '/minima_mdspassword/ s/:.*/: ${MDS_PASSWORD}/g' ${FILE}"

    # Стартуем контейнеры
    docker-compose up -d --scale minima=${INSTANCE_NUMBER}

    # Проверяем
    docker-compose ps -a

    docker run -d --restart unless-stopped --name watchtower -e WATCHTOWER_CLEANUP=true -e WATCHTOWER_TIMEOUT=60s -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower


elif [[ $# -eq 1 ]]
then
    docker exec -it root_minima_${1} minima
fi



