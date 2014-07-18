@runEveryFrame = (fn) ->
  runner = ->
    requestAnimationFrame(runner)
    fn()

  requestAnimationFrame(runner)
