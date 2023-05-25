openssl genrsa -traditional -out client.key 2048
openssl req -traditional -new -key client.key -out client.csr
openssl rsa -traditional -in client.key -pubout > client.pub