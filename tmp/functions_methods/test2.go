package main

import (
	"fmt"
	"strings"
)

func square(n int) int     { return n * n }
func negative(n int) int   { return -n }
func product(m, n int) int { return m * n }

func add1(r rune) rune { return r + 1 }

// 演示了函数值赋值，零值函数值引发panic，以及函数值作为参数值。
func main() {

	f := square
	fmt.Println(f(3)) // "9"

	f = negative
	fmt.Println(f(3))     // "-3"
	fmt.Printf("%T\n", f) // "func(int) int"

	// f = product // compile error: can't assign func(int, int) int to func(int) int
	var ff func(int) int
	ff(3) // 此处f的值为nil, 会引起panic错误

	// 使用函数值作为函数参数
	fmt.Println(strings.Map(add1, "HAL-9000")) // "IBM.:111"
	fmt.Println(strings.Map(add1, "VMS"))      // "WNT"
	fmt.Println(strings.Map(add1, "Admix"))    // "Benjy"
}
