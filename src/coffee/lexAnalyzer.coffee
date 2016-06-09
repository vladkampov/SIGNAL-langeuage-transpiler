class lexAnalyzer
    constructor: (@attr)-> 
        @analyze @attr.program

    analyzeLexeme: (lexeme, pos)->
        if @attr.config.keywords.indexOf(lexeme) >= 0
            return @attr.config.keywords[0] + @attr.config.keywords.indexOf(lexeme) - 1
        else if @attr.config.delimiters.indexOf(lexeme) >= 0
            return lexeme.charCodeAt(0);
        else if !parseInt(lexeme)
                @attr.identifiers.push lexeme: lexeme, code: @attr.config.identifiers   
                return @attr.config.identifiers++
            else 
                throw new Error chalk.red.bold "Wrong identifier " + lexeme + " on " + pos.row + ":" + pos.column

    newLine: (symbol, pos)->
        if symbol is '\n'
            pos.row += 1
            pos.column = 1
        else
            pos.column++

    analyze: (text)->
        text = text.toUpperCase()
        pos = row: 1, column: 1
        i = 0
        temp = ''
        comment = false
        star = false

        while true
            if text[i] is undefined
                break
            else
                lastLexeme = @attr.lexemes[@attr.lexemes.length - 1]

                # end comment check
                if comment
                    if text[i] is @attr.config.delimiters[6]
                        star = true
                    else if text[i] is  @attr.config.delimiters[2] and star
                        star = false
                        comment = false

                # parse
                else
                    if @attr.config.whitespaces.toString().indexOf(text[i]) is -1
                        if @attr.config.delimiters.toString().indexOf(text[i]) is -1
                            temp += text[i]
                        else
                            if temp
                                @attr.lexemes.push lexeme: temp, code: @analyzeLexeme(temp, pos), row: pos.row, column: pos.column
                                temp = ''
                            @attr.lexemes.push lexeme: text[i], code: @analyzeLexeme(text[i], pos), row: pos.row, column: pos.column
                    else
                        if temp
                            @attr.lexemes.push lexeme: temp, code: @analyzeLexeme(temp, pos), row: pos.row, column: pos.column
                            if @attr.config.delimiters.toString().indexOf(text[i]) isnt -1
                                @attr.lexemes.push lexeme: text[i], code: @analyzeLexeme(text[i], pos), row: pos.row, column: pos.column
                        temp = ''
                        @newLine text[i], pos

                # start comment check
                if lastLexeme
                    if lastLexeme.lexeme is @attr.config.delimiters[1] and text[i] is @attr.config.delimiters[6]
                        comment = true
                        @attr.lexemes.pop()
            i++
