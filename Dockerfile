FROM ubuntu:20.04

# install necessary dependencies
#RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Set python3.7 as the default python
#RUN update-alternatives --set python /usr/bin/python3.8
RUN apt-get update && \
    apt-get install -y wget python3-dev
RUN apt-get install -y build-essential
RUN apt-get install -y git
WORKDIR /opt

RUN python3 --version


COPY install_blast.sh /opt
RUN sh install_blast.sh

#Install Modeller
RUN mkdir modeller
WORKDIR /opt/modeller
RUN wget --no-check-certificate https://salilab.org/modeller/9.25/modeller_9.25-1_amd64.deb
RUN env KEY_MODELLER=MODELIRANJE dpkg -i /opt/modeller/modeller_9.25-1_amd64.deb

#Install muscle
WORKDIR /opt
COPY install_hmmer.sh /opt
RUN sh install_hmmer.sh

COPY install_ANARCI.sh /opt
RUN sh install_ANARCI.sh



RUN mkdir /NbModeling
COPY NbHumanization /opt/NbHumanization

RUN mkdir /data
RUN mkdir /data/BlastDB
COPY BlastDB /data/BlastDB

RUN apt-get install -y vim
RUN pip3 install pandas

RUN mkdir /opt/NanoNet

COPY NanoNet /opt/NanoNet

RUN mkdir /opt/protinter
COPY protinter /opt/protinter

RUN apt-get install -y zip
COPY resources.zip /opt
RUN unzip resources.zip

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y libglib2.0-0
RUN pip3 install prody
RUN pip3 install tensorflow==2.4.0

#WORKDIR /data
#CMD ["ANARCI","-h"]
