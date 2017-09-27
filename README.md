# Gotthard

A container that exposes remote ports to your containers via ssh local forwarding.


It is also possible to use a jump host:

* Specify the jump host via `JUMP_HOST`
* (Optional): Specify a jump user via `JUMP_USER`

## Examples

Suppose we want to expose PORT 8080 and 8081 to the containers in our network.

### bash:
```
docker run \
  -v ~/.ssh/:/root/.ssh/ \
  -p 8080:8080 \
  -p 8081:8081 \
  -e USER=florian \
  -e JUMP_HOST=my.jumphost.example.org
  -e HOST=example.org \
  -e PORTS=80:8080,81:8081  \
  stocard/gotthard
```

### docker-compose:
```
services:
  (...)
  gotthard:
    image: stocard/gotthard
    environment: 
      - USER=user
      - HOST=example.org
      - JUMP_HOST=my.jump_host.example.org
      - JUMP_USER=jump_user
      - PORTS=80:8080,81:8081
    volumes:
      - ~/.ssh/id_rsa:/root/.ssh/id_rsa
```

Your containers can now use `gotthard:80` or `gotthard:81` to talk to the remote server.
