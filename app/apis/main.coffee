fs = require 'fs'
path = require 'path'
storage = require '../helpers/storage'
input = path.resolve 'input'
output = path.resolve 'output'

sorting = (a, b) ->
	a = parseInt a
	b = parseInt b
	return a - b

exports.bind = (app) ->
	app.get '/apis/questions/next', (req, res) ->
		inputs = fs.readdirSync input
		outputs = fs.readdirSync output
		for file in inputs.sort sorting
			if outputs.indexOf(file) < 0 and !storage.exist(app, file)
				#this is the next
				content = fs.readFileSync path.join(input, file), 
					encoding: 'utf8'
				json = 
					file: file
					data: JSON.parse content
				storage.set app, file
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