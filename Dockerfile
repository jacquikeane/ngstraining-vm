#
#  From this base-image / starting-point
#
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y wget

RUN useradd -m -s /bin/bash software
