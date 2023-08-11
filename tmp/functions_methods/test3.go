package main

import "fmt"

// 演示defer语法
func main() {
	action := "打开资源"
	// defer method.invoke()
	defer func() {
		action := "关闭资源"
		fmt.Println(action)
	}()
	fmt.Println(action)
}
