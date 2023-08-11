package main

import (
	"fmt"
	"unsafe"
)

type Point struct {
	x int
	y int
}

func (p *Point) Square() int {
	fmt.Println("pointer cost", unsafe.Sizeof(p))
	return p.x * p.y
}

func (p Point) Add() int {
	fmt.Println("struct cost", unsafe.Sizeof(p))
	return p.x + p.y
}
func main() {
	p := Point{
		4,
		5,
	}
	fmt.Println(p)
	fmt.Println(p.Square())
	fmt.Println(p.Add())
}
