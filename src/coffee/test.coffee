string = "2020-06-31"
i = 0
currState = 0
temp = ''
words = []

while true
    if string[i] is undefined
        break
    else
        if currState is 0
            if string[i] is '-'
                if parseInt(temp).toString().length < 4
                    throw new Error "wrong year"
                else
                    words.push temp
                    temp = ''
                    currState++
            else
                temp += string[i]
        else if currState is 1
            if string[i] is '-'
                if parseInt(temp).toString().length < 2 and parseInt(temp) > 12
                    throw new Error "wrong month"
                else
                    words.push temp
                    temp = ''
                    currState++
            else
                temp += string[i]
        else if currState is 2
            if string[i + 1] is undefined
                if parseInt(temp).toString().length < 2 and parseInt(temp) > 31
                    throw new Error "wrong day"
                else
                    temp += string[i]
                    words.push temp
                    temp = ''
                    currState++
            else
                temp += string[i]
    i++
console.log words