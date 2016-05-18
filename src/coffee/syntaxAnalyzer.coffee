class syntaxAnalyzer
    constructor: (@attr)->
        @analyze @attr.lexemes

    scan: (lexemesArrs)->
        @current = lexemesArrs.shift()

    analyze: (lexemesArr)->
        @scan lexemesArr

    programBlock: ()->
        # TODO: check "PROCEDURE"
        @procedureIdentifierBlock()
        @parametersListBlock()
        # TODO: check ";"
        @block()
        # TODO: check ";"

    procedureIdentifierBlock: ()->

    parametersListBlock: ()->
        # TODO: check "("
        @declarationsListBlock()
        # TODO: check ")"
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

    procedureIdentifierBlock: ()->
        @identifierBlock()

    identifierBlock: ()->
        @letter()
        @string()

    letter: ()->
        # one of letter

    digit: ()->
        # one of digit

    string: ()->
        @letter()
        @string()
        # or
        @digit()
        @string()
        # or empty