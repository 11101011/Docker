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
    rsync \
    subversion \
    libapache2-svn 

ENV HOME=/home/openfoam
ENV MP=$HOME/OpenFOAM/openfoam-2.2.0/applications/solvers/multiphase
ENV MPP=$HOME/OpenFOAM/openfoam-2.2.0/applications/solvers/multiphase/phaseFieldFoam
ENV SRC1=$HOME/OpenFOAM/openfoam-2.2.0/
ENV SRC2=$HOME/
ENV OF=$HOME/OpenFOAM/
ENV SHARE=$HOME/OpenFOAM/share
ENV CASES=$HOME/OpenFOAM/Cases
# Important for correct OpenFOAM env variables
ENV USER=openfoam
ENV USERP=openfoam-2.2.0

RUN groupadd weiss --gid 1002 && useradd --no-log-init -s /bin/bash -r -g weiss --uid 1002 openfoam 

RUN mkdir -p $HOME/OpenFOAM/openfoam-2.2.0/applications/solvers/multiphase/phaseFieldFoam
RUN mkdir -p $HOME/OpenFOAM/Cases
RUN mkdir -p $HOME/OpenFOAM/share

WORKDIR $MP

RUN git clone https://github.com/11101011/phaseFieldFoam.git

WORKDIR $HOME/OpenFOAM/$USERP

RUN git clone https://github.com/11101011/src.git

WORKDIR $MPP

RUN chown -R openfoam:users /home/openfoam

USER openfoam:users

# All commands using OpenFOAM specific binaries need to be executed within the same shell environment
RUN ["/bin/bash", "-c", "source /opt/openfoam220/etc/bashrc && wclean && wmake"]

WORKDIR $HOME/OpenFOAM/$USERP/src/finiteVolume

RUN ["/bin/bash", "-c", "source /opt/openfoam220/etc/bashrc && wclean && wmake libso"]

WORKDIR $HOME/OpenFOAM/$USERP/src/turbulenceModels/incompressible/RAS

RUN ["/bin/bash", "-c", "source /opt/openfoam220/etc/bashrc && wclean && wmake libso"]

## INSTALL SWAK4FOAM

WORKDIR $SRC1

RUN git clone https://github.com/11101011/swak4Foam.git

WORKDIR $SRC1/swak4Foam

RUN ["/bin/bash", "-c", "source /opt/openfoam220/etc/bashrc && ./Allwmake"]

WORKDIR $HOME

COPY .bashrc .

# ----------------------------------------------------------------- end-of-file
