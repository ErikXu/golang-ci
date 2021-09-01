# golang-ci
Jenkins ci for golang

## 脚本说明

- publish.sh

  如果安装了 `golang` 环境, 执行该脚本发布可执行文件
  
- build.sh

  如果安装了 `docker`, 执行该脚本发布可执行文件

- pack.sh

  执行完 `publish.sh` 或 `build.sh` 后，执行该脚本打包 docker 镜像，并推送到 docker 仓库

- deploy.sh

  执行完 `pack.sh` 后，执行该脚本把应用部署到 kubernetes

## FAQ

### WARNING: IPv4 forwarding is disabled. Networking will not work

使用以下脚本解决 docker 容器无法访问外网的问题

``` bash
echo "net.ipv4.ip_forward=1" >>/usr/lib/sysctl.d/00-system.conf
systemctl restart network && systemctl restart docker
```
