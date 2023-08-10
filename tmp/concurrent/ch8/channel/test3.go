package main

import (
	"fmt"
	"time"
)

func main() {
	ch := make(chan int)

	go func() {
		for {
			// ture表示成功从channels接收到值，false表示channels已经被关闭并且里面没有值可接收。
			recv, ok := <-ch
			if ok {
				fmt.Println("recv", recv)
			} else {
				fmt.Println("No Received", recv)
			}
			time.Sleep(1 * time.Second)
		}
	}()

	for i := 0; i < 5; i++ {
		if i < 2 {
			ch <- i
		} else if i == 2 {
			close(ch)
		}
		time.Sleep(1 * time.Second)
	}
}
