docker build --build-arg HTTP_PROXY=http://host.docker.internal:7890 --build-arg HTTPS_PROXY=http://host.docker.internal:7890 --build-arg NO_PROXY=localhost,127.0.0.1 -t code-server:v1 .
