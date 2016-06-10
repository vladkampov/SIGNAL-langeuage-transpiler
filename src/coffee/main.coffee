Lexer = new lexAnalyzer lexemes: lexemes, identifiers: identifiers, config: config, program: program
printTable lexemes, chalk.yellow.bold "Lexical analyzer output"
printTable identifiers, chalk.yellow.bold "Identifiers table"
Syntaxer = new syntaxAnalyzer lexemes: lexemes, config: config
console.log chalk.yellow.bold "\n\nTREE:\n"
console.log prettyjson.render Syntaxer.tree
console.log chalk.yellow.bold "\n\nRESULT:\n"
Generator = new codeGenerator tree: Syntaxer.tree, identifiers: identifiers
console.log Generator.result
