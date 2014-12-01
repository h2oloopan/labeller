fs = require 'fs'
path = require 'path'
input = path.resolve 'input'
output = path.resolve 'output'

exports.bind = (app) ->
	app.get '/apis/questions/next', (req, res) ->
		inputs = fs.readdirSync input
		outputs = fs.readdirSync output
		for file in inputs
			if output.indexOf(file) < 0
				#this is the next
				content = fs.readFileSync path.join(input, file), 
					encoding: 'utf8'
				json = 
					file: file
					data: JSON.parse content
				return res.status(200).send json
		#all are done, nothing next
		return res.status(404).send {}
