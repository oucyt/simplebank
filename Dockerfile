# Build stage
FROM golang:1.19-alpine3.18 AS builder
# 指定后续指令的工作路径
WORKDIR /app
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct

# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

# 拷贝当前路径所有文件至容器的工作路径下
COPY . .
# 执行shell命令
# 预先下载依赖包：可以在本地机器上使用go mod download命令先下载所有依赖包到本地缓存中，然后将缓存目录挂载到Docker容器中，以加快Docker镜像的构建速度。
RUN go mod download && go build -o main main.go
# RUN apk --no-cache add curl
# RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.14.1/migrate.linux-amd64.tar.gz | tar xvz


# Run stage，全新基架
FROM alpine:3.18
WORKDIR /app
# 拷贝Build stage步骤中生成的可执行文件main
COPY --from=builder /app/main .
# 拷贝migrate可执行文件
# COPY --from=builder /app/3rd/migrate ./migrate
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./db/migration

EXPOSE 8080
CMD [ "/app/main" ]
# ENTRYPOINT [ "/app/wait-for.sh", "postgres:5432", "--", "/app/start.sh" ]
ENTRYPOINT [ "/app/wait-for.sh" ]