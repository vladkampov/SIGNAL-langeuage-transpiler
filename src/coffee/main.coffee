Lexer = new lexAnalyzer lexemes: lexemes, identifiers: identifiers, config: config, program: program
Tree = new tree
Syntaxer = new syntaxAnalyzer lexemes: lexemes, config: config, tree: Tree

printTable lexemes, chalk.yellow.bold "Lexical analyzer output"
printTable identifiers, chalk.yellow.bold "Identifiers table"
console.log prettyjson.render Syntaxer.tree
