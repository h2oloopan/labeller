path = require 'path'
fs = require 'fs'
folder = path.resolve 'apis'
index = 'pages/index.html'

exports.start = (app) ->
	files = fs.readdirSync folder
	(require path.join(folder, api)).bind app for api in files when path.extname(api) == '.js'

	app.get '/', (req, res) ->
		res.sendFile index,
			root: __dirname