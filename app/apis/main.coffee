fs = require 'fs'
path = require 'path'
input = path.resolve 'input'
output = path.resolve 'output'

exports.bind = (app) ->
	app.set 'current', []
	app.get '/apis/questions/next', (req, res) ->
		current = app.get 'current'
		inputs = fs.readdirSync input
		outputs = fs.readdirSync output
		for file in inputs
			if outputs.indexOf(file) < 0 and current.indexOf(file) < 0
				#this is the next
				content = fs.readFileSync path.join(input, file), 
					encoding: 'utf8'
				json = 
					file: file
					data: JSON.parse content
				current.push file
				app.set 'current', current
				return res.status(200).send json
		#all are done, nothing next
		return res.status(404).send {}

	app.post '/apis/questions/new', (req, res) ->
		file = req.body.file
		question = req.body.question
		questions = req.body.questions

		data = {}
		data[question] = questions
		data = JSON.stringify data
		file = path.join output, file
		try
			fs.writeFileSync file, data
		catch err
			return res.status(500).send err
		return res.status(200).send {}