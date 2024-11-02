FROM alpine:3.20.3 AS builder

ARG TARGETOS
ARG TARGETARCH

RUN --mount=type=cache,id=${TARGETARCH}/var/cache/apk,target=/var/cache/apk \
    apk add --update build-base bison

ADD /q3lcc /opt/q3lcc
ADD /q3asm /opt/q3asm

WORKDIR /opt

RUN cd q3lcc && make -j $(nproc) PLATFORM=${TARGETOS} ARCH=${TARGETARCH}
RUN cd q3asm && make -j $(nproc)

WORKDIR /opt/q3lcc/build-${TARGETOS}-${TARGETARCH}
RUN install -s -m 0755 q3lcc q3cpp q3rcc /usr/local/bin/

WORKDIR /opt/q3asm
RUN install -s -m 0755 q3asm /usr/local/bin/

FROM alpine:3.20.3

ARG TARGETOS
ARG TARGETARCH

RUN --mount=type=cache,id=${TARGETARCH}/var/cache/apk,target=/var/cache/apk \
    apk add --no-cache cmake bash ninja-build && rm /usr/bin/cpack /usr/bin/ctest

COPY --from=builder /usr/local/bin/q3asm /usr/local/bin/q3lcc /usr/local/bin/q3cpp /usr/local/bin/q3rcc /usr/local/bin/

# cmake needs to have some kind of cc installed, even if not used for regular C code
ENV CC="q3lcc" \
    PATH="$PATH:/usr/lib/ninja-build/bin"

WORKDIR /src