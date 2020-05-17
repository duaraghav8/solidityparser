#!/bin/bash

set -e

# This setup assumes you have antlr4 installed on your system
# as described at https://github.com/antlr/antlr4/blob/master/doc/getting-started.md
java \
    -Xmx500M \
    -cp "/usr/local/lib/antlr-4.8-complete.jar:$CLASSPATH" \
    org.antlr.v4.Tool \
    -Dlanguage=Go solidity-antlr4/Solidity.g4 \
    -package solidityparser \
    -o lib
mv lib/solidity-antlr4/* .

# Cleanup
rm -rf lib
