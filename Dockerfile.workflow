FROM codercom/code-server:debian

# 安装uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
COPY --from=mvdan/shfmt /bin/shfmt /bin/shfmt

# 切换到root用户
USER root
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# 安装必要包
RUN apt-get update && \
    apt-get install -y git fonts-wqy-zenhei locales curl build-essential && \
    echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    update-locale LANG=zh_CN.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 切换回非root用户
USER 1000

# 安装 nvm
ENV NVM_DIR=/home/coder/.nvm

# 安装nvm和node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash && \
    bash -c "source $NVM_DIR/nvm.sh && \
    nvm install --lts && \
    nvm alias default \$(nvm current) && \
    nvm use default"

# 设置环境变量使 node 和 npm 全局可用
RUN echo "export PATH=\"\$NVM_DIR/versions/node/\$(ls \$NVM_DIR/versions/node | head -1)/bin:\$PATH\"" >> ~/.bashrc

# 添加 nvm 自动加载到 bashrc (方便在终端使用)
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

# 取消 bashrc 中 ls aliases 的注释
RUN sed -i "s/^# *alias ls='/alias ls='/g" ~/.bashrc && \
    sed -i "s/^# *alias ll='/alias ll='/g" ~/.bashrc && \
    sed -i "s/^# *alias la='/alias la='/g" ~/.bashrc && \
    sed -i "s/^# *alias l='/alias l='/g" ~/.bashrc

# 预安装 extension
RUN code-server --install-extension MS-CEINTL.vscode-language-pack-zh-hans
RUN code-server --install-extension zhuangtongfa.material-theme
RUN code-server --install-extension yzhang.markdown-all-in-one
RUN code-server --install-extension shd101wyy.markdown-preview-enhanced
RUN code-server --install-extension shardulm94.trailing-spaces
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension GitHub.copilot-chat
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension mads-hartmann.bash-ide-vscode

# 配置默认主题
RUN mkdir -p $HOME/.local/share/code-server/User
RUN tee $HOME/.local/share/code-server/User/settings.json <<-'EOF'
{
    "workbench.colorTheme": "One Dark Pro"
}
EOF

# 配置镜像源（移到最后）
USER root
# 配置apt镜像源
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources

# 切换回非root用户
USER 1000

# 配置uv镜像源
RUN mkdir -p $HOME/.config/uv
RUN tee $HOME/.config/uv/uv.toml <<-'EOF'
[[index]]
url = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
default = true

python-install-mirror = "https://python-standalone.org/mirror/astral-sh/python-build-standalone/"
EOF

# 配置npm镜像源
RUN bash -c "source $NVM_DIR/nvm.sh && \
    export NVM_NODEJS_ORG_MIRROR=https://mirrors.ustc.edu.cn/node/ && \
    npm config set registry https://registry.npmmirror.com"