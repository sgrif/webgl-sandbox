class @Clock
  constructor: ->

  start: ->
    @getDelta()
    undefined

  getDelta: ->
    now = new Date().getTime()
    result = now - @lastDeltaTime
    @lastDeltaTime = now
    result
