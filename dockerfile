FROM debian:stretch

ARG ESPIDF_VERSION
ARG WORKDIR
ENV ESPIDF_VERSION=${ESPIDF_VERSION:-v3.2.3}
ENV WORKDIR=${WORKDIR:-/esp}

WORKDIR ${WORKDIR}

RUN apt-get update && \
    apt-get install -y gcc git wget make libncurses-dev flex bison gperf python python-pip python-setuptools \
            python-serial python-cryptography python-future picocom && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz && \
    tar -xzf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz && \
    rm -rf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

RUN git clone -b ${ESPIDF_VERSION} --recursive https://github.com/espressif/esp-idf.git && \
    cd esp-idf && \
    git submodule update --init --recursive && \
    python -m pip install --user -r requirements.txt

ENV PATH=${WORKDIR}/xtensa-esp32-elf/bin:$PATH
ENV ESPIDF=${WORKDIR}/esp-idf
ENV IDF_PATH=${WORKDIR}/esp-idf

CMD "/bin/bash"