package main

import (
	"fmt"
)

type Point struct {
	x int
	y int
}

func (p *Point) Square() int {
	if p == nil {
		return 100
	}
	return p.x * p.y
}

func main() {
	var p *Point
	fmt.Println(p.Square())
}
