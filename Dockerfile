FROM openjdk:11.0.13-jre-bullseye

RUN wget -q https://github.com/minima-global/Minima/raw/master/jar/minima.jar

EXPOSE 9001/tcp
EXPOSE 9002/tcp

VOLUME /data

CMD  java -Xmx1G -jar minima.jar  -daemon -port 9001 -data /data -rpcenable -rpc 9002
