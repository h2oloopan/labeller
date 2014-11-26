define ['../../set'], (set) ->
	return app =
		do: ->
			App = Ember.Application.create()
			App.ApplicationRoute = Ember.Route.extend
				model: ->
					#read model from local file system
					return set

			App.ApplicationController = Ember.ObjectController.extend
				needs: 'questions'
				file: {}
				counter: 0
				isAdded: false
				actions:
					next: ->
						counter = @get 'counter'

						if counter > 0 and !@get('isAdded')
							#add it to file
							file = @get 'file'
							request = @get 'controllers.questions.request'
							questions = @get 'controllers.questions.questions'
							selected = []
							for question in questions
								if question.isSelected then selected.push question.text
							file[request] = selected
							@set 'file', file

						list = @get 'model'
						keys = Object.keys list
						key = keys[counter]
						item = list[key]

						questions = []
						for one in item
							questions.push
								text: one
								isSelected: false

						@set 'controllers.questions.request', key
						@set 'controllers.questions.questions', questions
						@set 'counter', counter + 1
						return false
					dump: ->
						if @get('counter') > 0 and !@get('isAdded')
							#add it to file
							file = @get 'file'
							request = @get 'controllers.questions.request'
							questions = @get 'controllers.questions.questions'
							selected = []
							for question in questions
								if question.isSelected then selected.push question.text
							file[request] = selected
							@set 'file', file
							@set 'isAdded', true

						file = @get 'file'
						blob = new Blob [JSON.stringify file], {type: 'application/json;charset=utf-8'}
						fileName = (new Date()).toString()
						saveAs blob, fileName + '.json'
						return false

			App.QuestionsController = Ember.ArrayController.extend
				needs: ['question', 'application']
				#sortProperties: ['isSelected']
				#sortAscending: false
				actions:
					done: (questions) ->
						file = 
							question: @get 'controllers.application.questionTokens'
							answer: @get 'controllers.application.answerTokens'
							selected: []

						for question in questions
							if question.isSelected
								file.selected.push
									id: question.id
									questiontitle_original: question.questiontitle_original

						
						blob = new Blob [JSON.stringify file], {type: 'application/json;charset=utf-8'}
						fileName = ''
						for q in file.question
							fileName += q
							fileName += '-'
						fileName += '___'
						for a in file.answer
							fileName += a
							fileName += '-'
						saveAs blob, fileName + '.json'

			App.QuestionController = Ember.ObjectController.extend
				needs: 'questions'
			return false