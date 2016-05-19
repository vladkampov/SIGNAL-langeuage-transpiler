class tree
    constructor: (@attr)->
        @signalProgram = {}
        console.log @

class syntaxAnalyzer
    constructor: (@attr)->
        @tree = signalProgram: {} 
        @config = @attr.config
        @currentBranch = @tree

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
            throw new Error chalk.red.bold "program: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        @scan()
        @block()
        @scan()
        if @currentLex.lexeme isnt ";"
            throw new Error chalk.red.bold "Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

    procedureIdentifierBlock: ()->
        @identifierBlock()

    parametersListBlock: ()->
        if @currentLex.lexeme is "("
            @declarationsListBlock()

            if @currentLex.lexeme isnt ")"
                throw new Error chalk.red.bold "parametersList: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

            @scan()

    block: ()->
        @declarationsBlock()
        if @currentLex.lexeme isnt "BEGIN"
            throw new Error chalk.red.bold "block: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        @scan()
        @statementsListBlock()
        if @currentLex.lexeme isnt "END"
            throw new Error chalk.red.bold "block: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column

    statementsListBlock: ()->
        return "OK, its always empty"

    declarationsBlock: ()->
        @variableDeclarationsBlock()
    
    variableDeclarationsBlock: ()->
        if @currentLex.lexeme is "VAR"
            @declarationsListBlock()

    declarationsListBlock: ()->
        @scan()
        if @currentLex.lexeme isnt ")" and @config.keywords.indexOf(@currentLex.lexeme) is -1
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

    attributeBlock: ()->
        if @config.keywords.indexOf(@currentLex.lexeme) is -1
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