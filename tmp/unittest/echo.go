// Echo prints its command-line arguments.
package main

import (
	"flag"
	"fmt"
	"io"
	"os"
	"strings"
)

var (
	// 省略尾部换行符，
	n = flag.Bool("n", false, "omit trailing newline")
	//
	s = flag.String("s", " ", "separator")
)

var out io.Writer = os.Stdout // modified during testing

func main() {
	// 先解析，后使用
	flag.Parse()

	// 使用flag.Bool、flagString...获取带flag名的参数，例如:echo -n=3 -debug=false
	// flag.Args(),获取不带flag名的参数集合，例如:echo a b c 将返回[a b c]
	// flag.NArg(),获取flag.Args()返回的参数数量

	if err := echo(!*n, *s, flag.Args()); err != nil {
		fmt.Fprintf(os.Stderr, "echo: %v\n", err)
		os.Exit(1)
	}
}

// newline 输出后是否换行
// sep 用于输出时分隔non-flag参数
// args non-flag参数集合
func echo(newline bool, sep string, args []string) error {
	fmt.Fprint(out, strings.Join(args, sep))
	if newline {
		fmt.Fprintln(out)
	}
	return nil
}
