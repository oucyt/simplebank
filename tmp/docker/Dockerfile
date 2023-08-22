# Build stage
FROM golang:1.19-alpine3.18 AS builder

ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,direct

# 指定后续指令的工作路径
WORKDIR /app
COPY main.go main.go
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download


# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer

# RUN go mod download
