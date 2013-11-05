angular.module("pdifferenceApp").factory "Session", ($injector) ->

	Viewport = $injector.get "Viewport"
	Toolbelt = $injector.get "Toolbelt"

	class Session
		constructor: ->
			@shots = []
			@source = null
			@differences = []
			@id = _.uniqueId()
			@currentTab = null
			@currentShot = null
			@name = "Session #{@id}"
			@viewport = new Viewport this
			@toolbelt = new Toolbelt this
		addShot: (shot) -> @shots.push shot
		setName: (name) -> @name = name
		removeShot: (shot) ->
			array = null
			if _.contains @shots, shot
				array = @shots
			else if _.contains @differences, shot
				array = @differences

			return if array is null

			index = array.indexOf shot
			isLast = index is array.length - 1
			otherArray = if array is @shots then @differences else @shots

			_.pull array, shot

			if array.length > 0
				nextShot = if isLast then array[index - 1] else array[index]
				@setCurrentShot nextShot
			else if otherArray > 0
				@setCurrentShot otherArray[otherArray.length - 1]
			else
				@currentShot = null
		addDifference: (diff) -> @differences.push diff
		removeDifference: (shot) ->
			_.pull @differences, shot
			if @differences.length < 1 and @shots.length > 1
				@setCurrentShot @shots[0]
		findSource: ->
			@source = _.find group.shots, (shot) ->
				shot.type is "source"
		getShotById: (id) -> _.find @shots, (shot) -> shot.id is id
		getDifferenceById: (id) -> _.find @differences, (shot) -> shot.id is id
		setCurrentShot: (shot) ->
			@currentTab = shot. id
			@currentShot = shot
		moveToShot: (index) ->
			return if @currentShot is null
			shotArray = @getActiveSet()
			@setCurrentShot shotArray[index] if shotArray.length > index >= 0
		getActiveSet: ->
			return if @currentShot is null
			if @currentShot.type is "difference" then @differences else @shots
		getActiveSetIndex: ->
			set = @getActiveSet()
			return if not angular.isArray set
			set.indexOf @currentShot


	return Session
