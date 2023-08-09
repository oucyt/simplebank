package u4

import (
	"os"
	"testing"
)

// [Go语言标准库文档中文版 | Go语言中文网 | Golang中文社区 | Golang中国 (studygolang.com)](https://studygolang.com/pkgdoc)
func TestMain(m *testing.M) {
	// call flag.Parse() here if TestMain uses flags
	// 如果 TestMain 使用了 flags，这里应该加上 flag.Parse()
	os.Exit(m.Run())
}
