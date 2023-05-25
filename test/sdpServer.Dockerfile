FROM ubuntu:18.04

WORKDIR /app

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

USER root

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y make automake curl git net-tools conntrack openssl libssl-dev libjson-c-dev libpcap-dev texinfo libtool autoconf libuv1 libuv1-dev
RUN apt-get install -y iptables

# Install Go
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

COPY openspa /app/openspa

# Build openspa
RUN cd /app/openspa && go build -o /app/spa ./cli/openspa

COPY runServer.sh /app/runServer.sh

COPY server.yml /app/server.yml

RUN chmod +x /app/runServer.sh

# Wait forever
CMD tail -f /dev/null
