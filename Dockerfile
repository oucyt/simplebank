# Build stage
FROM golang:1.19-alpine3.18 AS builder
# 指定后续指令的工作路径
WORKDIR /app
# 拷贝当前路径所有文件至容器的工作路径下
COPY . .
# 执行shell命令
# 预先下载依赖包：可以在本地机器上使用go mod download命令先下载所有依赖包到本地缓存中，然后将缓存目录挂载到Docker容器中，以加快Docker镜像的构建速度。
RUN go env -w GOPROXY=https://goproxy.cn,direct && go mod download && go build -o main main.go
# RUN go env -w GOPROXY=https://goproxy.cn,direct && go env

# Run stage
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .

EXPOSE 8080
CMD [ "/app/main" ]