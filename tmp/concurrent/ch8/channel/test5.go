package main

import (
	"fmt"
	"strconv"
	"time"
)

func main() {
	ch1 := make(chan int)
	ch2 := make(chan string)
	ch3 := make(chan bool)
	y := true

	go func() {
		for i := 0; i < 10; i++ {
			if i%2 == 0 {
				ch1 <- i
			} else {
				ch2 <- strconv.Itoa(i)
			}
			time.Sleep(1 * time.Second)
		}
	}()

	for {
		select {
		case <-ch1:
			fmt.Println("ch1接收到新值")
		case x := <-ch2:
			fmt.Println("ch2接收到新值", x)
		case ch3 <- y:
			// ...
		default:
			// ...
		}
	}
}
