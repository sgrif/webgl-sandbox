class @Joint
  constructor: (@name, @parent, @rotation, @translation) ->

  Object.defineProperties @prototype,
    transformationMatrix:
      get: ->
        @parent.transformationMatrix.times(@relativeMatrix)

    relativeMatrix:
      get: ->
        @rotation.toMatrix().translate(@translation)
