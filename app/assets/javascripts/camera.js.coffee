class @Camera
  constructor: ({ @position, @perspective }) ->

  Object.defineProperties @prototype,
    worldPosition:
      get: ->
        inverseView = @position.matrix.inverse
        inverseView.timesVector(Vector4.ORIGIN)
