# 启动项目

1. make postgres 创建容器
2. make createdb 创建测试数据库
3. make migrateup 创建测试表

# Visual Studio Code Debug
F5  开始调试
F10 单步执行
F11 进入函数/跳出函数

SHIFT + F5 停止调试

# 解决Visual Studio Code执行test时不打印相关日志

用户 - 首选项 - 设置 -扩展（Go）- Go:Test Flags

"go.testFlags": [  
    "-v"
]

# 解决proto文件代码提示import错误提示
vscode-proto3插件添加如下设置：

"protoc": {
    "options": [
        "--proto_path=proto",
    ]
}

# server容器如何与postgreSQL容器通信

## 方案1

1. 查出postgreSQL容器当前的ip，docker network inspect bridge 
2. 启动server容器时通过指定环境变量的方式传递ip，docker run --name simplebank -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE=postgresql://root:root@{{ip}}:5432/simple_bank?sslmode=disable simplebank:latest 

## 方案2

1. 创建自定义bridge网络，docker network create my_bridge;
2. 将server容器和postgreSQL容器加入my_bridge中，docker network connect my_server my_postgresql.(ps, 也可以在启动容器时通过 --network 参数指定要加入的网络,示例如下)

```shell
 docker run --name simplebank --network my_bridge -p 8080:8080  -e GIN_MODE=release -e DB_SOURCE=postgresql://root:root@my_postgresql:5432/simple_bank?sslmode=disable simplebank:latest
```
问题记录
1. 先创建my_bridge，将镜像加入网络后，宿主机无法访问容器，而且容器也无法访问外部网络。删除重建my_bridge后解决