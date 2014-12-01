define ['ehbs!templates/index', 'ehbs!templates/questions'], () ->
	return app =
		do: ->
			App = Ember.Application.create()

			App.Router.map ->
				@route 'index',
					path: '/'


			App.IndexView = Ember.View.extend
				didInsertElement: ->
					@_super()
					$('.btn-next').click()

			App.IndexController = Ember.ObjectController.extend
				needs: 'questions'
				actions:
					next: ->
						thiz = @
						update = ->
							$.get 'apis/questions/next', (data) ->
								key = Object.keys(data.data)[0]
								questions = []
								for q in data.data[key]
									questions.push
										isSelected: false
										text: q

								data =
									file: data.file
									question: key
									questions: questions

								thiz.set 'controllers.questions.model', data
							.fail (err) ->
								thiz.set 'controllers.questions.model', 
									question: 'There is nothing to label at the moment'

						data = @get 'controllers.questions.model'
						if data? and data.file?
							@send 'done', update
						else
							update()
							
						
						return false
					done: (cb) ->
						data = @get 'controllers.questions.model'
						questions = data.questions.filter (q) ->
							if q.isSelected then return true
							return false
						questions = questions.map (q) ->
							return q.text

						upload = 
							file: data.file
							question: data.question
							questions: questions

						$.ajax
							type: 'POST'
							url: 'apis/questions/new'
							data: JSON.stringify upload
							dataType: 'json'
							contentType: 'application/json; charset=utf-8'
							success: (res) ->
								if cb? then cb res
							failure: (res) ->
								console.log res

						return false


			App.QuestionsController = Ember.ObjectController.extend {}
