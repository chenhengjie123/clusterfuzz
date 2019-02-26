FROM ubuntu:16.04

RUN mkdir /clusterfuzz
COPY ./ /clusterfuzz/
WORKDIR /clusterfuzz

ENV DEBIAN_FRONTEND noninteractive

EXPOSE 9000

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get install -y \
        apt-transport-https \
        build-essential \
        curl \
        gdb \
        libcurl4-openssl-dev \
        libffi-dev \
        libssl-dev \
        locales \
        lsb-release \
        net-tools \
        python \
        python-dbg \
        python-dev \
        python-pip \
        socat \
        sudo \
        unzip \
        util-linux \
        wget \
        zip \
        vim \
        nginx

# google cloud sdk
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y

# other dependencies
RUN local/install_deps.bash
# RUN source ENV/bin/activate
# RUN cd src && bazel run //local:create_gopath
# RUN cd local && python polymer_bundler.py 
# WORKDIR /clusterfuzz

# open bash for debug
CMD ["/bin/bash"]
