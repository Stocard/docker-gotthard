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
  -e PORTS=80:8080,81:8081  \
  gotthard
```

### docker-compose:
```
services:
  (...)
  gotthard:
    image: fbarth/gotthard
    environment: 
      - USER=user
      - HOST=example.org
      - PORTS=80:8080,81:8081
    volumes:
      - ~/.ssh/id_rsa:/root/.ssh/id_rsa
```

Your containers can now use `gotthard:80` or `gotthard:81` to talk to the remote server.
