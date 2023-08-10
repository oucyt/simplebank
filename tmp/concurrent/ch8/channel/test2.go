package main

import (
	"fmt"
	"time"
)

// 测试发送端和接收端的阻塞效果
func main() {
	ch := make(chan int)
	defer close(ch)
	go func() {
		for {
			var recv = <-ch
			fmt.Println("recv ", recv)
			time.Sleep(1 * time.Second)
		}
	}()

	for i := 0; i < 10; i++ {
		ch <- i
	}
}
