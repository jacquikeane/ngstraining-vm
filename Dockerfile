#
#  From this base-image / starting-point
#
FROM ubuntu:20.04

RUN apt-get update

RUN sudo useradd -m -s /bin/bash software
