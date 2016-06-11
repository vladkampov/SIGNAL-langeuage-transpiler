class codeGenerator
    constructor: (@attr)-> 
        @tree = @attr.tree
        @identifiers = @attr.identifiers
        @result = ''
        @stack = []
        @signalFlag = false
        @blockFlag = false
        @alreadyUsed = []
        @walk @tree

    whatIsIt: (object)->
        stringConstructor = "".constructor
        arrayConstructor = [].constructor
        objectConstructor = {}.constructor

        if object is null
            return "null"
        else if object is undefined
            return "undefined"
        else if object.constructor is stringConstructor
            return "String"
        else if object.constructor is arrayConstructor
            return "Array"
        else if object.constructor is objectConstructor
            return "Object"
        else 
            return "don't know"

    generateEqu: (identifiers, type, block)->
        types = 
            INTEGER: 4
            FLOAT: 8,
            EXT: 8,
            BLOCKFLOAT: 8,
            COMPLEX: 8
        sign = if block
            '-'
        else
            '+'

        arr = identifiers.map (el)->
            return el + ' equ [EBP' + sign + types[type] + ']\n'
        return arr.toString().replace(/\,/g, "")

    walk: (node)->
        type = @whatIsIt node
        if type is "Object"
            for key, value of node
                if key is "signalProgram"
                    @result += "CODE SEGMENT\n\n"
                    @walk value
                    @result += "\nCODE ENDS\n"
                else if key is "procedureIdentifierBlock"
                    @alreadyUsed.push value
                    @result += "_" + value + ":\n"
                else if key is "variableIdentifierBlock"
                    @stack.push value
                    @walk value
                else if key is "attributeBlock"
                    if value is "SIGNAL"
                        @signalFlag = true
                    else
                        @result += @generateEqu @stack, value, @blogFlag
                        @signalFlag = false
                        @stack = []
                else if key is "block"
                    @blogFlag = true
                    @walk value
                else
                    @walk value
        else if type is "Array"
            node.map (value)=>
                if value is "BEGIN"
                    @result += "\n\npush ebp\nmov ebp,esp\nsub esp,16"
                if value is "END"
                    @result += "\n\nadd esp,16\npop ebp\n\nret\n"
                @walk value
        else if type is "String"
            if  @alreadyUsed.indexOf(node) > -1
                throw new Error chalk.red.bold "Semantic Error: " + node + " identifier already used."
            @alreadyUsed.push node
            return
