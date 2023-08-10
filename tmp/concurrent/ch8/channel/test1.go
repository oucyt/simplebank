package main

import (
	"fmt"
	"time"
)

func main() {
	ch := make(chan int)
	defer close(ch)
	go func() {
		for {
			var recv = <-ch
			// if recv == 5 {
			// 	close(ch)
			// }
			fmt.Println("recv ", recv)
		}
	}()

	for i := 0; i < 10; i++ {
		// 对一个已关闭的ch发送数据将会引发panic
		// panic: send on closed channel
		// 		panic: close of closed channel

		// ch <- i

		if i < 5 {
			ch <- i
		}
		time.Sleep(1 * time.Second)
	}
}
