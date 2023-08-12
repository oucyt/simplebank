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