package main

import (
	"fmt"
)

// makeThumbnails makes thumbnails of the specified files.
func makeThumbnails(filenames []string) {
	ch := make(chan struct{})
	for _, f := range filenames {
		go func(f string) {
			thumb, err := ImageFile(f)
			fmt.Println(thumb)
			if err != nil {
				fmt.Println(err)
			}
			ch <- struct{}{}
		}(f)
	}
	// Wait for goroutines to complete.
	for range filenames {
		<-ch
	}
}

// 该版本不能返回工作goroutine的值
func main() {
	files := []string{
		"1.jpg",
		"2.jpg",
		"3.jpg",
	}
	makeThumbnails(files)
}
