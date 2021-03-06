angular.module("pdifferenceApp").factory "Socket", (Shot, $document) ->

  bind = angular.bind

  class Socket
    constructor: (@session) ->
      @connected = false
      @io = io.connect "http://localhost"

      @io.on "send:onConnect", bind(this, @onConnect)
      # @io.on "data:chunk", bind(this, @onDataChunk)
      # @io.on "data:end", bind(this, @onDataEnd)

    onConnect: (event) ->
      @connected = true
      console.log event.message

    emit: (event, data) -> @io.emit event, data

    captureScreen: (shotData, callback) ->
      buffers = ""
      url = shotData.url
      @takingShot = true
      
      onChunk = (data) -> buffers += data.data
      onEnd = (data) =>
        image = "data:image/png;base64,#{btoa buffers}"
        @io.removeListener 'data:end', onEnd
        @io.removeListener 'data:chunk', onChunk
        @session.addShot new Shot
          displayURL: url
          path: image
          width: shotData.shotWidth
          height: shotData.shotHeight
        callback()
       
      @io.emit "send:takeShot", shotData
      @io.on "data:chunk", onChunk
      @io.on "data:end", onEnd

    getConfig: (callback) ->
      onConfigRecieve = (config) =>
        callback config
        @io.removeListener "data:config"

      @io.on "data:config", onConfigRecieve
      @io.emit "send:getConfig"

    saveConfig: (config) -> @io.emit "send:saveConfig", config
