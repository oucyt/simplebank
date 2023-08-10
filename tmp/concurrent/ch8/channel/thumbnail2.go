package main

import (
	"fmt"
)

// makeThumbnails makes thumbnails of the specified files.
func makeThumbnails(filenames []string) {
	for _, f := range filenames {
		go func() {
			thumb, err := ImageFile(f)
			fmt.Println(thumb)
			if err != nil {
				fmt.Println(err)
			}
		}()
	}
}

// 该版本中，工作goroutine还未执行完毕，主goroutine就结束了
func main() {
	files := []string{
		"1.jpg",
		"2.jpg",
		"3.jpg",
	}
	makeThumbnails(files)
}
