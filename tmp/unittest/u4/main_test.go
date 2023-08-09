package u4

import (
	"fmt"
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	fmt.Println("invoke TestMain")
	// call flag.Parse() here if TestMain uses flags
	// 如果 TestMain 使用了 flags，这里应该加上 flag.Parse()
	os.Exit(m.Run())
}
