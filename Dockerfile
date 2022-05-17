FROM --platform=linux/amd64 ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y make gcc

ADD . /repo
WORKDIR /repo/make/linux
RUN make -j8
RUN make install
WORKDIR /repo/examples/linux
RUN make -j8
