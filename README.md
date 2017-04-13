# Gotthard

A container that exposes remote ports to your containers via ssh local forwarding.


## Examples

Suppose we want to expose PORT 8080 and 8081 to the containers in our network.

### bash:
```
docker run \
  -v ~/.ssh/:/root/.ssh/ \
  -p 8080:8080 \
  -p 8081:8081 \
  -e USER=florian \
  -e HOST=example.org \
  -e PORTS=8080,8081  \
  gotthard
```

### docker-compose:
```
services:
  (...)
  gotthard:
    image: fbarth/gotthard
    ports:
      - 8080:8080
      - 8081:8081
    environment: 
      - USER=user
      - HOST=example.org
      - PORTS=8080,8081
    volumes:
      - ~/.ssh/id_rsa:/root/.ssh/id_rsa
```

Your containers can now use `gotthard:8080` or `gotthard:8081` to talk to the remote server.

