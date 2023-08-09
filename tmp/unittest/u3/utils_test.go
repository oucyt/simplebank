package util

import "fmt"

func ExampleIsPalindrome() {
	fmt.Println(IsPalindrome("A man, a plan, a canal: Panama"))
	fmt.Println(IsPalindrome("palindrome"))
	fmt.Println(IsPalindrome("cbabc"))
	// Output:
	// false
	// false
	// true
}
