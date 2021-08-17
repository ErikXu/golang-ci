FROM alpine:3.14

ENV GIN_MODE release
RUN mkdir /app
WORKDIR /app
COPY . /app/.

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update
RUN apk add tini

EXPOSE 8080

ENTRYPOINT ["tini", "--"]
CMD ["/app/app"]
