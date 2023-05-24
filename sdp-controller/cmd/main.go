package main

import (
	"fmt"
	"github.com/akamensky/argparse"
	"os"
)

var parser *argparse.Parser

func main() {
	if os.Getegid() != 0 {
		fmt.Println("You're not sudo!")
		return
	}

	parser = argparse.NewParser(
		"Secure-SDP",
		"Secure Software-Defined Perimeter OpenSource implementation")

}
