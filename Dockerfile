FROM debian:bookworm-slim AS builder

ARG TARGETOS
ARG TARGETARCH

RUN apt-get update -qq && apt-get install -qq --no-install-recommends build-essential bison

ADD /q3lcc /opt/q3lcc
WORKDIR /opt/q3lcc

RUN make -j $(nproc) PLATFORM=${TARGETOS} ARCH=${TARGETARCH}

WORKDIR /opt/q3lcc/build-${TARGETOS}-${TARGETARCH}

RUN  install -s -m 0755 q3lcc q3cpp q3rcc /usr/local/bin/

FROM debian:bookworm-slim

RUN apt-get update -qq && apt-get install -qq --no-install-recommends build-essential cmake ninja-build && mkdir /src

COPY --from=builder /usr/local/bin/q3lcc /usr/local/bin/q3cpp /usr/local/bin/q3rcc /usr/local/bin/

WORKDIR /src