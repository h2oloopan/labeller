moment = require 'moment'
token = 'current'
expiry = 30

storage = module.exports = 
	clear: (app) ->
		app.set token, {}
	set: (app, key) ->
		data = app.get token
		if !data? then data = {}
		data[key] = moment().add(expiry, 'm').unix()
		app.set token, data
	exist: (app, key) ->
		data = app.get token
		if data? 
			item = data[key]
			if item?
				if moment().unix() > item
					delete data[key]
					return false
				else
					return true
			else
				return false
		else
			return false
