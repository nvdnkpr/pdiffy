angular.module("pdifferenceApp").controller "uploaderCtrl", ($scope, Shot) ->

	forEach = angular.forEach

	$scope.uploadedFiles = []

	$scope.onFileSelect = (files) ->
		$scope.uploadedFiles.push file for file in files
	
	uploadImage = (file) ->
		reader = new FileReader()
		alertId = $scope.addAlert
			loading: true
			msg: "Loading image #{file.name}"

		reader.onload = (e) ->
			$scope.removeAlert alertId
			addScreenShot e.target.result, file
			$scope.$apply()

		$scope.uploader.hide()
		reader.readAsDataURL file

	addScreenShot = (data, file) ->
		shot = new Shot()
		shot.displayURL = file.name
		shot.screen.path =  data

		$scope.activeSession.shots.push shot
		$scope.activeSession.setCurrentShot shot
	
	$scope.upload = -> forEach $scope.uploadedFiles, uploadImage

	$scope.$watch "uploader.open", (value) -> $scope.uploadedFiles = [] if value is true

	return

