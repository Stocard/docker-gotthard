# Gotthard

A container that exposes remote ports to your containers via ssh local forwarding.
The container will try to use all files in the **folder** that is mounted on `/root/.ssh/` to authenticate. 
Mounting single files, will not work, as docker volume mounting only works on folders.

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
