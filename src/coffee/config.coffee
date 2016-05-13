fs = require 'fs'
path = require 'path'
chalk = require 'chalk'
json_tb = require 'json-table'

configFile = path.join(__dirname, '../..', 'config', 'config.json')
testFile = path.join(__dirname, '../..', 'config', 'testfile.signal')
config = JSON.parse fs.readFileSync configFile, 'utf-8'

program = if process.argv[2] is undefined
    fs.readFileSync testFile, 'utf-8'
else
    fs.readFileSync process.argv[2], 'utf-8'

lexemes = []
identifiers = []

printTable = (obj, title)->
	console.log "\n", title
	table = new json_tb obj, null, (table)-> 
		table.show()
	console.log "\n"