package main

import (
	"fmt"
	"math/rand"
	"time"
)

func ImageFile(f string) (string, error) {
	rand.Seed(time.Now().UnixNano())
	delay := rand.Int63n(3)
	time.Sleep(time.Duration(delay) * time.Second)
	return f[:len(f)-len(".jpg")] + ".thumb.jpg", nil
}

// makeThumbnails makes thumbnails of the specified files.
func makeThumbnails(filenames []string) {
	for _, f := range filenames {
		thumb, err := ImageFile(f)
		fmt.Println(thumb)
		if err != nil {
			fmt.Println(err)
		}
	}
}

// 该版本中未使用并发
func main() {
	files := []string{
		"1.jpg",
		"2.jpg",
		"3.jpg",
	}
	makeThumbnails(files)
}
