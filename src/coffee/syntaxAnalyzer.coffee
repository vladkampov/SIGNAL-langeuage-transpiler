class tree
    constructor: (@attr)->
        @signalProgram = {}

class syntaxAnalyzer
    constructor: (@attr)->
        @tree = {} 
        @config = @attr.config

        @analyze()

    scan: ()->
        @currentLex = @attr.lexemes.shift()

    analyze: ()->
        @scan()
        return @tree = signalProgram: @programBlock()

    programBlock: ()->
        obj = []
        if @currentLex.lexeme isnt @config.keywords[1]
            throw new Error chalk.red.bold "program: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        obj.push @currentLex.lexeme
        @scan()
        obj.push procedureIdentifierBlock: @procedureIdentifierBlock()
        @scan()
        obj.push parametersListBlock: @parametersListBlock()
        @scan()
        if @currentLex.lexeme isnt @config.delimiters[3]
            throw new Error chalk.red.bold "program: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        @scan()
        obj.push block: @block()
        @scan()
        if @currentLex.lexeme isnt @config.delimiters[3]
            throw new Error chalk.red.bold "Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        return obj

    procedureIdentifierBlock: ()->
        @identifierBlock()
        return @currentLex.lexeme

    parametersListBlock: ()->
        obj = {}
        if @currentLex.lexeme is @config.delimiters[1]
            obj = @declarationsListBlock {}

            if @currentLex.lexeme isnt @config.delimiters[2]
                throw new Error chalk.red.bold "parametersList: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
            return obj

    block: ()->
        obj = []
        obj.push declarationsBlock: @declarationsBlock()
        if @currentLex.lexeme isnt @config.keywords[2]
            throw new Error chalk.red.bold "block: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        obj.push @currentLex.lexeme
        @scan()
        obj.push statementsListBlock: @statementsListBlock()
        if @currentLex.lexeme isnt @config.keywords[3]
            throw new Error chalk.red.bold "block: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        obj.push @currentLex.lexeme
        return obj

    statementsListBlock: ()->
        return {}

    declarationsBlock: ()->
        return @variableDeclarationsBlock()
    
    variableDeclarationsBlock: ()->
        obj = []
        if @currentLex.lexeme is @config.keywords[4]
            obj.push @currentLex.lexeme, declarationsListBlock: @declarationsListBlock {}
            return obj
        else
            return {}

    declarationsListBlock: (obj)->
        @scan()
        if @currentLex.lexeme isnt @config.delimiters[2] and @config.keywords.indexOf(@currentLex.lexeme) is -1
            obj['declarationBlock'] = @declarationBlock()
            obj['declarationsListBlock'] = @declarationsListBlock {}
            return obj

    declarationBlock: ()->
        obj = {}
        obj['variableIdentifierBlock'] = @variableIdentifierBlock()
        obj['identifiersListBlock'] = @identifiersListBlock {}

        if @currentLex.lexeme isnt @config.delimiters[4]
            throw new Error chalk.red.bold "declaration: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        @scan()
        obj['attributeBlock'] = @attributeBlock()
        obj['attributeListBlock'] = @attributeListBlock {}
        if @currentLex.lexeme isnt @config.delimiters[3]
            throw new Error chalk.red.bold "declaration: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        return obj

    identifiersListBlock: (obj)->
        @scan()
        if @currentLex.lexeme is @config.delimiters[5]
            @scan()
            obj['variableIdentifierBlock'] = @variableIdentifierBlock()
            obj['identifiersListBlock'] = @identifiersListBlock identifiersListBlock: {}
            return obj

    attributeListBlock: (obj)->
        @scan()
        if @currentLex.lexeme isnt @config.delimiters[3]
            obj['attributeBlock'] = @attributeBlock()
            obj['attributeListBlock'] = @attributeListBlock {}
            return obj

    attributeBlock: ()->
        if @config.keywords.indexOf(@currentLex.lexeme) is -1
            throw new Error chalk.red.bold "attribute: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        return @currentLex.lexeme

    variableIdentifierBlock: ()->
        @identifierBlock()
        return @currentLex.lexeme

    identifierBlock: ()->
        obj = {}
        obj['letter'] = @letter @currentLex.lexeme.slice 0, 1
        obj['string'] = @string @currentLex.lexeme.slice(1, @currentLex.lexeme.length), {}
        return obj

    letter: (char)->
        if !char.match(/[a-z]/i)
            throw new Error chalk.red.bold "letter: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        return char

    digit: (char)->
        if !char.match(/[0-9]/i)
            throw new Error chalk.red.bold "digit: Syntax Error at " + @currentLex.lexeme + " on " + @currentLex.row + ":" + @currentLex.column
        return char

    string: (str, obj)->
        if str isnt ""
            if parseInt(str)
                obj['digit'] = @digit str.slice 0, 1
            else
                obj['letter'] = @letter str.slice 0, 1
            obj['string'] = {}
            @string str.slice(1, str.length), obj['string']
            return obj
