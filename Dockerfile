FROM ubuntu:20.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update \
    && apt-get -y -u dist-upgrade \
    && apt-get -y --no-install-recommends install \
        ca-certificates g++ gcc git libasound2-dev libavformat-dev libfaad-dev \
        libflac-dev liblirc-dev libmad0-dev libmpg123-dev libsoxr-dev libvorbis-dev make

RUN git clone https://github.com/ralph-irving/squeezelite /tmp/squeezelite

WORKDIR /tmp/squeezelite

RUN make LDFLAGS="-lm -lrt -L./lib -L/usr/local/lib -s -lgomp" OPTS="-DDSD -DRESAMPLE -DVISEXPORT -DFFMPEG -DLINKALL -DIR -DGPIO -DRPI -s -march=native" \
    && chmod +x squeezelite \
    && mv squeezelite /usr/local/bin/

FROM ubuntu:20.04

COPY --from=builder /usr/local/bin/squeezelite /usr/local/bin/

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
        libasound2 libavformat58 libfaad2 libflac8 liblircclient0 libmad0 \
        libmpg123-0 libsoxr0 libvorbis0a \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER nobody

ENTRYPOINT ["squeezelite"]
