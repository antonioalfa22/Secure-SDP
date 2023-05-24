FROM ubuntu:20.04

WORKDIR /sdpclient

# INSTALL Go
RUN apt-get update && apt-get install -y \
    wget \
    git \
    gcc \
    make \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://golang.org/dl/go1.19.9.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.19.9.linux-amd64.tar.gz
RUN rm go1.19.9.linux-amd64.tar.gz

# SET GOPATH and GOROOT
RUN mkdir /home/go
ENV GOPATH=/home/go
ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Copy opensdp folder

COPY openspa /sdpclient/openspa

# Wait forever
CMD tail -f /dev/null
