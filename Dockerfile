FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /tmp/

RUN apt-get update \
    && apt-get -y -u dist-upgrade \
    && apt-get -y --no-install-recommends install \
        ca-certificates g++ gcc git libasound2-dev libavformat-dev libfaad-dev libflac-dev liblirc-dev libmad0-dev libmpg123-dev libsoxr-dev libvorbis-dev make \
    && git clone https://github.com/ralph-irving/squeezelite \
    && cd squeezelite \
    && make LDFLAGS="-lasound -lpthread -lm -lrt -L./lib -L/usr/local/lib -s -lgomp" OPTS="-DDSD -DRESAMPLE -DVISEXPORT -DFFMPEG -DLINKALL -DIR -DGPIO -DRPI -s -march=native" \
    && chmod +x squeezelite \
    && mv squeezelite /usr/local/bin/ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT squeezelite -M HiFiBerry -m $MAC -n $PLAYER -o $OUTPUT_DEVICE -s $SERVER -d all=info
