package main

import "fmt"

func foo() {
	defer func() {
		fmt.Println("资源回收")
	}()
	panic("我抛出了一个panic")
}

func bar() {
	defer func() {
		if p := recover(); p != nil {
			fmt.Println("捕获到一个panic，internal error:", p)
		}
		fmt.Println("资源回收")
	}()
	panic("我抛出了一个panic")
}

// 测试recover的恢复机制
func main() {
	fmt.Println("start")
	foo()
	// bar()
	fmt.Println("end")
}
