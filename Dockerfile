FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y make gcc

ADD . /repo
WORKDIR /repo/make/linux
RUN make -j8
RUN make install
WORKDIR /repo/examples/linux
RUN make -j8

RUN mkdir -p /deps
RUN ldd /repo/examples/linux/disasm | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /repo/examples/linux/disasm /repo/examples/linux/disasm
ENV LD_LIBRARY_PATH=/deps
