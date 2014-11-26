require.config
	baseUrl: 'js/libs'
	paths:
		templates: 'templates'
		app: '../app'
	shim:
		'bootstrap': ['jquery']
		'ember': ['handlebars', 'jquery']
		'ember-data': ['ember']
		'app': ['ember', 'ember-data', 'bootstrap', 'filesaver']

require ['app'], (app) ->
	app.do()