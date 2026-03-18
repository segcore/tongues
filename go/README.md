# go

Go programming language, by google. https://go.dev/

## Installation

Download and extract the go package somewhere and add it to PATH.

```sh
# see: https://go.dev/doc/install
wget https://go.dev/dl/go1.26.1.linux-amd64.tar.gz
tar -C ~/.local -xf go1.26.1.linux-amd64.tar.gz
```

Add to path:
```sh
export PATH="$HOME/.local/go/bin:$PATH"
```

## Running

```sh
go build cat.go
./cat < README.md

# or,
go run cat.go < README.md
```
