# Solidity Parser
This is a Go module to parse [Solidity](https://solidity.readthedocs.io/en/latest/), based on [Federico](https://github.com/federicobond) 's [ANTLR grammar](https://github.com/solidityj/solidity-antlr4) for the language.

## Usage
`sample.sol`

```
contract Foo {
	constructor() {}
	function bar(uint x) {}
}
```

`main.go`

```go
package main

import (
	"fmt"
	"github.com/antlr/antlr4/runtime/Go/antlr"
	"github.com/duaraghav8/solidityparser"
	"os"
)

type TreeShapeListener struct {
	*solidityparser.BaseSolidityListener
}

func NewTreeShapeListener() *TreeShapeListener {
	return new(TreeShapeListener)
}

func (l *TreeShapeListener) EnterEveryRule(ctx antlr.ParserRuleContext) {
	fmt.Println(ctx.GetText())
}

func main() {
	code, _ := antlr.NewFileStream("./sample.sol")
	lexer := solidityparser.NewSolidityLexer(code)
	stream := antlr.NewCommonTokenStream(lexer, 0)
	p := solidityparser.NewSolidityParser(stream)
	p.AddErrorListener(antlr.NewDiagnosticErrorListener(true))
	p.BuildParseTrees = true
	tree := p.SourceUnit()
	antlr.ParseTreeWalkerDefault.Walk(NewTreeShapeListener(), tree)
}
```

## Building
Install the ANTLR4 tool and the Go runtime as described [here](https://github.com/antlr/antlr4/blob/master/doc/getting-started.md) & [here](https://github.com/antlr/antlr4/blob/master/doc/go-target.md).

To generate this Parser:
1. Update the `solidity-antlr4` [submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to the appropriate commit.
2. Run `scripts/generate-solidity-parser.sh` in the root directory of this repository.
3. Run `go mod tidy && go mod vendor`
4. Commit and push.
