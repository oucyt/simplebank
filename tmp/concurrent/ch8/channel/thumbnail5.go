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
	// return f[:len(f)-len(".jpg")] + ".thumb.jpg", errors.New("一个错误")
}

// makeThumbnails makes thumbnails of the specified files.
func makeThumbnails(filenames []string) (thumbfiles []string, err error) {
	type item struct {
		thumbfile string
		err       error
	}
	ch := make(chan item, len(filenames))
	for _, f := range filenames {
		go func(f string) {
			var it item
			it.thumbfile, it.err = ImageFile(f)
			ch <- it
		}(f)
	}
	for range filenames {
		it := <-ch
		if it.err != nil {
			return nil, it.err
		}
		thumbfiles = append(thumbfiles, it.thumbfile)
	}
	return thumbfiles, nil
}

func main() {
	files := []string{
		"1.jpg",
		"2.jpg",
		"3.jpg",
	}
	thumbfiles, err := makeThumbnails(files)
	if err == nil {
		for k, v := range thumbfiles {
			fmt.Println(k, v)
		}
	}
}
