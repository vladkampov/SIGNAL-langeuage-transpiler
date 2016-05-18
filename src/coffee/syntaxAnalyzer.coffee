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
            throw new Error chalk.red.bold "Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

        @scan()
        @procedureIdentifierBlock()
        @scan()
        @parametersListBlock()
        # TODO: check ";"
        # @block()
        # TODO: check ";"

    procedureIdentifierBlock: ()->
        @identifierBlock()

    parametersListBlock: ()->
        if @currentLex.lexeme isnt "("
            throw new Error chalk.red.bold "Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

        @scan()
        console.log @currentLex
        # @declarationsListBlock()
        # if @currentLex.lexeme isnt ")"
        #     throw new Error chalk.red.bold "Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        # or empty 

    block: ()->
        @declarationsBlock()
        # TODO: check "BEGIN"
        @statementsListBlock()
        # TODO: check "END"

    statementsListBlock: ()->
        # always empty

    declarationsBlock: ()->
        @variableDeclarationsBlock()
    
    variableDeclarationsBlock: ()->
        # TODO: check "VAR"
        @declarationsListBlock()
        # or empty

    declarationsListBlock: ()->
        @declarationBlock()
        @declarationsListBlock()
        # or empty

    declarationBlock: ()->
        @variableIdentifierBlock()
        @identifiersListBlock()
        # TODO: check ":"
        @attributeBlock()
        @attributeListBlock()
        # TODO: check ";"
    
    identifiersListBlock: ()->
        # TODO: check ","
        @variableIdentifierBlock()
        @identifiersListBlock()
        # or empty

    attributeListBlock: ()->
        @attributeBlock()
        @attributeListBlock()
        # or empty

    attributeBlock: ()->
        # one og config.keywords

    variableIdentifierBlock: ()->
        @identifierBlock()

    identifierBlock: ()->
        @letter @currentLex.lexeme.slice 0, 1
        @string @currentLex.lexeme.slice 1, @currentLex.lexeme.length

    letter: (char)->
        if !char.match(/[a-z]/i)
            throw new Error chalk.red.bold "Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

    digit: (char)->
        if !char.match(/[0-9]/i)
            throw new Error chalk.red.bold "Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

    string: (str)->
        if str isnt ""
            if parseInt(str)
                @digit str.slice 0, 1
            else
                @letter str.slice 0, 1
            @string str.slice 1, str.length