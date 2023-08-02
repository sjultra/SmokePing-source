FROM ubuntu:20.04

# copy thirdparty independently
COPY . ./app

RUN apt-get --assume-yes update && apt-get --assume-yes install librrds-perl rrdtool dma

RUN ./release-smokeping.sh

CMD ["./bin/smokeping", "--version"]