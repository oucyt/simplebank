package main

import (
	"errors"
	"fmt"
	"math/rand"
	"time"
)

func ImageFile(f string) (string, error) {
	rand.Seed(time.Now().UnixNano())
	delay := rand.Int63n(3)
	time.Sleep(time.Duration(delay) * time.Second)
	// return f[:len(f)-len(".jpg")] + ".thumb.jpg", nil
	return f[:len(f)-len(".jpg")] + ".thumb.jpg", errors.New("一个错误")
}

// makeThumbnails makes thumbnails of the specified files.
func makeThumbnails(filenames []string) error {
	errors := make(chan error)

	for _, f := range filenames {
		go func(f string) {
			_, err := ImageFile(f)
			errors <- err
		}(f)
	}

	for range filenames {
		if err := <-errors; err != nil {
			fmt.Println(err)
			// bug，如果接收到一个err，直接return。导致其他goroutine发送err时阻塞，造成goroutine泄露
			return err // NOTE: incorrect: goroutine leak!
		}
	}

	return nil
}

// 该版本存在一个 goroutine leak!
func main() {
	files := []string{
		"1.jpg",
		"2.jpg",
		"3.jpg",
	}
	makeThumbnails(files)
}
