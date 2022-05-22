# 使用 alpine 作为基础镜像
FROM alpine:3.14

# 设置 Gin Mode 为 release
ENV GIN_MODE release

# 拷贝可执行文件到 /app
COPY . /app

# 设置 /app 为工作目录
WORKDIR /app

# 操作系统使用阿里云的源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 安装 tini
RUN apk update
RUN apk add tini

# 暴漏 8080 端口
EXPOSE 8080

# 使用 tini 模式启动程序
ENTRYPOINT ["tini", "--"]
CMD ["/app/app"]
