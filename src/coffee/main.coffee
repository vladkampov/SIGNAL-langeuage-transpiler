Lexer = new lexAnalyzer lexemes: lexemes, identifiers: identifiers, config: config, program: program
printTable lexemes, chalk.yellow.bold "Lexical analyzer output"
# printTable identifiers, chalk.yellow.bold "Identifiers table"
# Tree = new tree
# Syntaxer = new syntaxAnalyzer lexemes: lexemes, config: config, tree: Tree
# console.log prettyjson.render Syntaxer.tree
