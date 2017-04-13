FROM alpine

RUN apk update &&  apk add openssh-client bash && rm /var/cache/apk/*
COPY entrypoint.sh ./entrypoint.sh
CMD bash entrypoint.sh