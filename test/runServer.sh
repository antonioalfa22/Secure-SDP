#!/usr/bin/env bash

# =========================================> iptables <=========================================
iptables -I INPUT -p udp -m udp --dport 22211 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 22212 -j ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -S

# =========================================> Generate the certificates <=========================================
cd ~
openssl rand -writerand .rnd
# Generate the certificates
cd /app
# Create certs if folder does not exist
if ! [ -d certs ]; then
    mkdir certs
    cd certs
    openssl genrsa -out server.key 2048
    openssl req -new -key server.key -out server.csr -passin pass:antonio -subj "/C=ES/ST=PA/L=A/O=Uniovi/OU=SE/CN=sdp/emailAddress=abc@xyz.com"
    openssl rsa -in server.key -pubout > server.pub
    rm server.csr

    # Generate the client (c3b66a05-9098-4100-8141-be5695ada0e7) certificates
    openssl genrsa -out c3b66a05-9098-4100-8141-be5695ada0e7.key 2048
    openssl req -new -key c3b66a05-9098-4100-8141-be5695ada0e7.key -out c3b66a05-9098-4100-8141-be5695ada0e7.csr -passin pass:antonio -subj "/C=ES/ST=PA/L=A/O=Uniovi/OU=SE/CN=PhD/emailAddress=abc@xyz.com"
    openssl rsa -in c3b66a05-9098-4100-8141-be5695ada0e7.key -pubout > c3b66a05-9098-4100-8141-be5695ada0e7.pub
    rm c3b66a05-9098-4100-8141-be5695ada0e7.csr
    # Move to the /app/certs/clients folder
    [ -d clients ] || mkdir clients
    mv c3b66a05-9098-4100-8141-be5695ada0e7.* ./clients
fi
# =========================================> Run server <=========================================
cd /app
# Run the server
./spa server --config /app/server.yml