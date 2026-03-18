package main

import "io"
import "os"
import "log"

func main() {
	if _, err := io.Copy(os.Stdout, os.Stdin); err != nil {
		log.Fatal(err)
	}
}
