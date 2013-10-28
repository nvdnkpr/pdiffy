angular.module("pdifferenceApp").directive "center", ($injector) ->

	$window = $injector.get "$window"
	$timeout = $injector.get "$timeout"

	(scope, element, attrs) ->
		adjust = ->
			element.css
				"left": "50%"
				"margin-left": -(element[0].clientWidth / 2) + "px"

		scope.$on "centerElements", -> $timeout adjust, 0

		angular.element($window).bind "resize", _.throttle(adjust, 50)

		adjust()

		return