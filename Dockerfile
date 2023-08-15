# Build stage
FROM golang:1.19-alpine AS builder
# 指定后续指令的工作路径
WORKDIR /a/b/c
# 拷贝当前路径所有文件至容器的工作路径下
COPY . .
# 执行shell命令
RUN go env -w GOPROXY=https://goproxy.cn,direct && go build -o main main.go
# RUN go env -w GOPROXY=https://goproxy.cn,direct && go env