# Gotthard

A container that exposes remote ports to your containers via ssh local forwarding.
The container will try to use all files in the **folder** that is mounted on `/root/.ssh/` to authenticate. 
Mounting single files, will not work, as docker volume mounting only works on folders.

:warning: If your SSH key requires a passphrase, please specify it using `SSH_KEY_PASSPHRASE` environment variable.

It is also possible to use jump hosts:
* Specify the desired jump host(s) the following way (as value of `JUMP_HOSTS`): 
  * `JUMP_USER@JUMP_HOST`
  * `JUMP_USER1@JUMP_HOST1,JUMP_USER2@JUMP_HOST2`

## Examples

Suppose we want to expose PORT 8080 and 8081 to the containers in our network.

### bash:
```
docker run \
  -v ~/.ssh/:/root/.ssh/ \
  -p 8080:8080 \
  -p 8081:8081 \
  -e USER=florian \
  -e JUMP_HOSTS=user1@my.jumphost.example.org,user3@my.other.jumphost.example.org
  -e HOST=example.org \
  -e PORTS=80:8080,81:8081  \
  stocard/gotthard
```

Suppose we want to expose PORT 8080 and 8081 of `host my.endhost.example.org`, which is reachable 
by the host `example.org`, to the containers in our network.

### bash:
```
docker run \
  -v ~/.ssh/:/root/.ssh/ \
  -p 8080:8080 \
  -p 8081:8081 \
  -e USER=florian \
  -e JUMP_HOSTS=user1@my.jumphost.example.org,user3@my.other.jumphost.example.org
  -e HOST=example.org \
  -e HOSTS_AND_PORTS=80:my.endhost.example.org:8080,81:my.endhost.example.org:8081  \
  stocard/gotthard
```

You could also combine both approaches:

```
docker run \
  -v ~/.ssh/:/root/.ssh/ \
  -p 8080:8080 \
  -p 8081:8081 \
  -e USER=florian \
  -e JUMP_HOSTS=user1@my.jumphost.example.org,user3@my.other.jumphost.example.org
  -e HOST=example.org \
  -e PORTS=80:8080,81:8081  \
  -e HOSTS_AND_PORTS=82:my.endhost.example.org:8082,83:my.endhost.example.org:8083  \
  stocard/gotthard
```

This forwards port 80 and 81 from the Host and 82 and 83 from `my.endhost.example.org`.


### docker-compose:
```
services:
  (...)
  gotthard:
    image: stocard/gotthard
    environment: 
      - USER=user
      - HOST=example.org
      - JUMP_HOSTS=user@my.jump_host.example.org
      - PORTS=80:8080,81:8081
    volumes:
      - ~/.ssh/:/root/.ssh/
```

Your containers can now use `gotthard:80` or `gotthard:81` to talk to the remote server.

```
services:
  (...)
  gotthard:
    image: stocard/gotthard
    environment: 
      - USER=user
      - HOST=example.org
      - JUMP_HOSTS=user@my.jump_host.example.org
      - PORTS=80:8080,81:8081
      - HOSTS_AND_PORTS=82:my.endhost.example.org:8082,83:my.endhost.example.org:8083
    volumes:
      - ~/.ssh/:/root/.ssh/
```

Your containers can now use `gotthard:80`, `gotthard:81`, `gotthard:82` or `gotthard:83` to talk to the remote server.
