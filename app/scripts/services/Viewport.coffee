angular.module("pdifferenceApp").factory "Viewport", ($injector) ->

	$window = $injector.get "$window"

	class Zoom
		constructor: (@viewport)->
			@level = 1
		increase: (amount=0.1) ->
			@level += amount
			@viewport.adjust()
		decrease: (amount=0.1) ->
			@level -= amount
			@viewport.adjust()
		reset: ->
			@level = 1
			@viewport.adjust()

	class Viewport
		constructor: (@session) ->
			@left = 0
			@top = 0
			@width = 0
			@height =  0
			@canvasWidth = 0
			@canvasHeight = 0
			@zoom = new Zoom(this)
		center: ->
			if @session.currentShot isnt null
				shot = @session.currentShot
				offsetX = shot.screenPosition.x * @zoom.level
				offsetY = shot.screenPosition.y * @zoom.level
				width = shot.width * @zoom.level
				height = shot.height * @zoom.level
				x = (@left + offsetX) + ((width - $window.innerWidth) / 2)
				y = (@top + offsetY) + ((height - $window.innerHeight) / 2)
				@setPosition x, y
		setPosition: (x=$window.pageXOffset, y=$window.pageYOffset) -> $window.scrollTo x, y
		adjust: ->
			# TODO: account for images that are smaller than window size
			shots = @session.shots.concat @session.differences
			maxHeight = @session.getMaxHeight()
			maxWidth = @session.getMaxWidth()
			@canvasWidth = maxWidth
			@canvasHeight = maxHeight
			@left = $window.innerWidth - 200
			@top = $window.innerHeight - 200
			@height = maxHeight * @zoom.level + (@top * 2)
			@width = maxWidth * @zoom.level + (@left * 2)

	return Viewport
