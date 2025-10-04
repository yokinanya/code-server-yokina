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
docker run -d --name code-server -p 8080:8080 \
  -v "$HOME/.config:/home/coder/.config" \
  -v "code-server-data:/home/coder/.local" \
  -v "$PWD:/home/coder/project" \
  -v /etc/localtime:/etc/localtime:ro \
  -u "$(id -u):$(id -g)" \
  -e "DOCKER_USER=$USER" \
  --add-host host.docker.internal:host-gateway \
  ghcr.io/yokinanya/code-server-yokina:latest
```

访问 http://localhost:8080

## 本地构建

### 使用代理构建（推荐）
```bash
# 使用代理构建脚本
./build-with-proxy.sh
```

### 直接构建
```bash
# 本地构建（使用Dockerfile，镜像源配置在前面）
docker build -t yokinanya/code-server-yokina:local -f ./Dockerfile .
```

## Dockerfile 说明

项目包含两个 Dockerfile ：

- `Dockerfile` : 用于本地构建，镜像源配置在前面，确保构建过程中使用国内镜像源加速
- `Dockerfile.workflow` : 用于 GitHub Actions 构建时使用，镜像源配置在最后，避免在 CI 环境中可能出现的镜像源问题
