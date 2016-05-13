analyzeLexeme = (lexeme, pos)->
    if config.keywords.indexOf(lexeme) >= 0
        return config.keywords[0] + config.keywords.indexOf(lexeme) - 1
    else if config.delimiters.indexOf(lexeme) >= 0
        return lexeme.charCodeAt(0);
    else if !parseInt(lexeme)
            identifiers.push lexeme: lexeme, code: config.identifiers   
            return config.identifiers++
        else 
            throw new Error chalk.red.bold "Wrong identifier " + lexeme + " on " + pos.row + ":" + pos.column

newLine = (symbol, pos)->
    if symbol is '\n'
        pos.row += 1
        pos.column = 1
    else
        pos.column++

Lexer = (text)->
    text = text.toUpperCase()
    pos = row: 1, column: 1
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
                    lexemes.push lexeme: text[i], code: analyzeLexeme(text[i], pos), row: pos.row, column: pos.column
            else
                if temp
                    lexemes.push lexeme: temp, code: analyzeLexeme(temp, pos), row: pos.row, column: pos.column
                temp = ''
                newLine text[i], pos
        i++
