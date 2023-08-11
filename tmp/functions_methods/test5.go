package main

import "fmt"

type Point struct {
	x int
	y int
}

func (p Point) Square() int {
	return p.x * p.y
}
func main() {
	p := Point{
		4,
		5,
	}
	fmt.Println(p)
	fmt.Println(p.Square())
	fmt.Println(main.Square(p))
}
