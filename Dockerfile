FROM alpine

RUN apk update &&  apk add openssh-client bash && rm /var/cache/apk/*

RUN mkdir -p ~/.ssh/
COPY entrypoint.sh ./entrypoint.sh

CMD bash entrypoint.sh
