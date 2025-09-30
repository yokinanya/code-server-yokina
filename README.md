# Coder Server Docker

定制化的 code-server 镜像，预装中文环境和开发工具。

## 特性

- 中文界面 + 字体
- UV (Python) + NVM (Node.js)
- 国内镜像源加速
- 预装常用扩展

## 使用

```bash
# 拉取镜像
docker pull ghcr.io/yokinanya/code-server-yokina:latest

# 运行
docker run -d --name code-server -p 127.0.0.1:8080:8080 \
  -v "$HOME/.config:/home/coder/.config" \
  -v "$PWD:/home/coder/project" \
  -v /etc/localtime:/etc/localtime:ro \
  -u "$(id -u):$(id -g)" \
  -e "DOCKER_USER=$USER" \
  --add-host host.docker.internal:host-gateway \
  ghcr.io/yokinanya/code-server-yokina:latest
```

访问 http://localhost:8080

## 本地构建

```bash
docker build -t yokinanya/code-server-yokina:local .
```
