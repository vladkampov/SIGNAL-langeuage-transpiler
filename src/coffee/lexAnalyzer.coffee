analyzeLexeme = (lexeme, row, column)->
    if config.keywords.toString().indexOf(lexeme) >= 0
        return 'keyword'
    else if config.delimiters.toString().indexOf(lexeme) >= 0
        return 'delimiter'
    else if !parseInt(lexeme)
            return "identifier"
        else 
            throw new Error chalk.red.bold "Wrong identifier " + lexeme + " on " + row + ":" + column

newLine = (symbol, row, column)->
    if symbol is '\n'
        row += 1
        column = 1
    else
        column++

Lexer = (text)->
    text = text.toUpperCase()
    identifiers = {}
    constants = {}
    errors = []
    row = 1
    column = 1
    i = 0
    temp = ''

    while true
        if text[i] is undefined
            break
        else
            if config.whitespaces.toString().indexOf(text[i]) is -1
                if config.delimiters.toString().indexOf(text[i]) is -1
                    temp += text[i]
                else
                    console.log text[i], analyzeLexeme text[i], row, column
            else
                if temp
                    console.log temp, analyzeLexeme temp, row, column
                temp = ''
                newLine text[i], row, column
        i++
