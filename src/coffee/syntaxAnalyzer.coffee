class syntaxAnalyzer
    constructor: (@attr)->
        @analyze()

    scan: ()->
        @currentLex = @attr.lexemes.shift()

    analyze: ()->
        @scan()
        @programBlock()

    programBlock: ()->
        if @currentLex.lexeme isnt "PROCEDURE"
            throw new Error chalk.red.bold "program: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

        @scan()
        @procedureIdentifierBlock()
        @scan()
        @parametersListBlock()
        if @currentLex.lexeme isnt ";"
            throw new Error chalk.red.bold "Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        # @block()
        # if @currentLex.lexeme isnt ";"
        #     throw new Error chalk.red.bold "Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

    procedureIdentifierBlock: ()->
        @identifierBlock()

    parametersListBlock: ()->
        if @currentLex.lexeme is "("
            @declarationsListBlock()

            if @currentLex.lexeme isnt ")"
                throw new Error chalk.red.bold "parametersList: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

            @scan()

    block: ()->
        # @declarationsBlock()
        # TODO: check "BEGIN"
        # @statementsListBlock()
        # TODO: check "END"

    statementsListBlock: ()->
        # always empty

    declarationsBlock: ()->
        # @variableDeclarationsBlock()
    
    variableDeclarationsBlock: ()->
        # TODO: check "VAR"
        # @declarationsListBlock()
        # or empty

    declarationsListBlock: ()->
        @scan()
        if @currentLex.lexeme isnt ")"
            @declarationBlock()
            @declarationsListBlock()

    declarationBlock: ()->
        @variableIdentifierBlock()
        @identifiersListBlock()
        if @currentLex.lexeme isnt ":"
            throw new Error chalk.red.bold "declaration: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        @scan()
        @attributeBlock()
        @attributeListBlock()
        if @currentLex.lexeme isnt ";"
            throw new Error chalk.red.bold "declaration: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

    identifiersListBlock: ()->
        @scan()
        if @currentLex.lexeme is ","
            @scan()
            @variableIdentifierBlock()
            @identifiersListBlock()

    attributeListBlock: ()->
        @scan()
        if @currentLex.lexeme isnt ";"
            @attributeBlock()
            @attributeListBlock()
        # or empty

    attributeBlock: ()->
        if @attr.config.keywords.indexOf(@currentLex.lexeme) is -1
            throw new Error chalk.red.bold "attribute: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

    variableIdentifierBlock: ()->
        @identifierBlock()

    identifierBlock: ()->
        @letter @currentLex.lexeme.slice 0, 1
        @string @currentLex.lexeme.slice 1, @currentLex.lexeme.length

    letter: (char)->
        if !char.match(/[a-z]/i)
            throw new Error chalk.red.bold "letter: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

    digit: (char)->
        if !char.match(/[0-9]/i)
            throw new Error chalk.red.bold "digit: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

    string: (str)->
        if str isnt ""
            if parseInt(str)
                @digit str.slice 0, 1
            else
                @letter str.slice 0, 1
            @string str.slice 1, str.length