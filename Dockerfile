FROM ubuntu:12.04

MAINTAINER Sebastian Weiss (sebastianw@posteo.de)

ARG DEBIAN_FRONTEND=noninteractive

RUN sh -c "echo deb http://dl.openfoam.org/ubuntu precise main > /etc/apt/sources.list.d/openfoam.list"
RUN apt-get update && apt-get install -y \
    --force-yes openfoam220 \
    git-core \
    build-essential \
    flex \
    bison \
    nano \
    htop \
    wget \
    rsync

ENV HOME=/home/openfoam
ENV MP=$HOME/OpenFOAM/openfoam-2.2.0/applications/solvers/multiphase
ENV MPP=$HOME/OpenFOAM/openfoam-2.2.0/applications/solvers/multiphase/phaseFieldFoam
ENV SHARE=$HOME/OpenFOAM/share
ENV CASES=$HOME/OpenFOAM/Cases
# Important for correct OpenFOAM env variables
ENV USER=openfoam

RUN useradd --no-log-init -s /bin/bash -r -g users --uid 1000 openfoam 

RUN mkdir -p $HOME/OpenFOAM/openfoam-2.2.0/applications/solvers/multiphase/phaseFieldFoam
RUN mkdir -p $HOME/OpenFOAM/Cases
RUN mkdir -p $HOME/OpenFOAM/share

WORKDIR $MP

RUN git clone https://github.com/11101011/phaseFieldFoam.git

WORKDIR $MPP

RUN chown -R openfoam:users /home/openfoam

USER openfoam:users

# All commands using OpenFOAM specific binaries need to be executed within the same shell environment
RUN ["/bin/bash", "-c", "source /opt/openfoam220/etc/bashrc && wclean && wmake"]

WORKDIR $HOME

COPY .bashrc .

# ----------------------------------------------------------------- end-of-file
