package main

import "fmt"

// 测试带缓存的channel
func main() {
	ch := make(chan int, 3)
	fmt.Println(cap(ch)) // "3"

	ch <- 0
	ch <- 1
	fmt.Println(len(ch)) // "2"

}
