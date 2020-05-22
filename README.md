# Solidity Parser
This is a Go module to parse [Solidity](https://solidity.readthedocs.io/en/latest/), based on [Federico](https://github.com/federicobond) 's [ANTLR grammar](https://github.com/solidityj/solidity-antlr4) for the language.

## Usage
```go
package main

import (
	"fmt"
	"github.com/antlr/antlr4/runtime/Go/antlr"
	"github.com/duaraghav8/solidityparser"
)

var code = `
contract Foo {
	function bar(uint x) {}
}

contract Bar {
	constructor(){}
}
`

// EverythingListener listens for all rules, i.e., it visits
// all AST nodes.
type EverythingListener struct {
	*solidityparser.BaseSolidityListener
}

func NewEverythingListener() *EverythingListener {
	return new(EverythingListener)
}

func (l *EverythingListener) EnterEveryRule(ctx antlr.ParserRuleContext) {
	fmt.Println("Entered a rule")
	fmt.Println(ctx.GetRuleIndex())
	fmt.Printf("Text: %s\nStart line: %d\n", ctx.GetText(), ctx.GetStart().GetLine())
	fmt.Println("--------------")
}

func main() {
	code := antlr.NewInputStream(code)
	lexer := solidityparser.NewSolidityLexer(code)
	stream := antlr.NewCommonTokenStream(lexer, 0)

	parser := solidityparser.NewSolidityParser(stream)
	parser.AddErrorListener(antlr.NewDiagnosticErrorListener(true))
	parser.BuildParseTrees = true

	tree := parser.SourceUnit()
	antlr.ParseTreeWalkerDefault.Walk(NewEverythingListener(), tree)
}
```

## Building
Install the ANTLR4 tool and the Go runtime as described [here](https://github.com/antlr/antlr4/blob/master/doc/getting-started.md) & [here](https://github.com/antlr/antlr4/blob/master/doc/go-target.md).

To generate this Parser:
1. Update the `solidity-antlr4` [submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to the appropriate commit.
2. Run `scripts/generate-solidity-parser.sh` in the root directory of this repository.
3. Run `go mod tidy && go mod vendor`
4. Commit and push.
